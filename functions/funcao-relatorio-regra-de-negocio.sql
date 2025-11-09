DROP FUNCTION fn_analise_orcamento;
DROP TYPE tb_analise_orcamento;
DROP TYPE tp_analise_orcamento;

CREATE OR REPLACE TYPE tp_analise_orcamento AS OBJECT (
        usuario          VARCHAR2(200),
        email            VARCHAR2(255),
        nome_orcamento   VARCHAR2(50),
        categoria        VARCHAR2(50),
        tipo_categoria   VARCHAR2(10),
        periodo_inicio   DATE,
        periodo_fim      DATE,
        dias_periodo     NUMBER,
        limite_orcamento NUMBER(
            14,
            2
        ),
        total_gasto      NUMBER(
            14,
            2
        ),
        percentual_usado NUMBER(
            5,
            2
        ),
        saldo_disponivel NUMBER(
            14,
            2
        ),
        qtd_transacoes   NUMBER,
        gasto_medio_dia  NUMBER(
            14,
            2
        ),
        projecao_final   NUMBER(
            14,
            2
        ),
        status_orcamento VARCHAR2(20),
        nivel_alerta     VARCHAR2(15)
);
/

CREATE OR REPLACE TYPE tb_analise_orcamento AS
    TABLE OF tp_analise_orcamento;
/

CREATE OR REPLACE FUNCTION fn_analise_orcamento (
    p_user_id         IN NUMBER DEFAULT NULL,
    p_categoria_id    IN NUMBER DEFAULT NULL,
    p_data_referencia IN DATE DEFAULT sysdate
) RETURN tb_analise_orcamento
    PIPELINED
IS
    v_dias_periodo     NUMBER;
    v_dias_decorridos  NUMBER;
    v_total_gasto      NUMBER(
        14,
        2
    );
    v_percentual_usado NUMBER(
        5,
        2
    );
    v_saldo_disponivel NUMBER(
        14,
        2
    );
    v_qtd_transacoes   NUMBER;
    v_gasto_medio_dia  NUMBER(
        14,
        2
    );
    v_projecao_final   NUMBER(
        14,
        2
    );
    v_status_orcamento VARCHAR2(20);
    v_nivel_alerta     VARCHAR2(15);
    v_linha            tp_analise_orcamento;
BEGIN
    FOR r_orcamento IN (
        SELECT u.full_name,
               u.email,
               b.budget_id,
               b.name AS budget_name,
               c.name AS category_name,
               c.type AS category_type,
               b.start_date,
               b.end_date,
               b.limit_value,
               u.user_id,
               b.category_id
          FROM p_budget b
         INNER JOIN p_user u
        ON b.user_id = u.user_id
          LEFT JOIN p_category c
        ON b.category_id = c.category_id
         WHERE ( p_user_id IS NULL
            OR u.user_id = p_user_id )
           AND ( p_categoria_id IS NULL
            OR b.category_id = p_categoria_id )
           AND b.start_date <= p_data_referencia
           AND b.end_date >= p_data_referencia
         ORDER BY u.full_name,
                  b.start_date,
                  b.name
    ) LOOP
        v_dias_periodo := trunc(r_orcamento.end_date) - trunc(r_orcamento.start_date) + 1;
        v_dias_decorridos := least(
            trunc(p_data_referencia) - trunc(r_orcamento.start_date) + 1,
            v_dias_periodo
        );

        IF r_orcamento.category_id IS NOT NULL THEN
            SELECT nvl(
                sum(t.transaction_value),
                0
            ),
                   COUNT(t.transaction_id)
              INTO
                v_total_gasto,
                v_qtd_transacoes
              FROM p_transaction t
             INNER JOIN p_transaction_category tc
            ON t.transaction_id = tc.transaction_id
             INNER JOIN p_category c
            ON tc.category_id = c.category_id
             WHERE tc.category_id = r_orcamento.category_id
               AND t.transaction_date BETWEEN r_orcamento.start_date AND least(
                p_data_referencia,
                r_orcamento.end_date
            )
               AND t.has_occurred = 1
               AND c.type = 'expense';
        ELSE
            SELECT nvl(
                sum(t.transaction_value),
                0
            ),
                   COUNT(t.transaction_id)
              INTO
                v_total_gasto,
                v_qtd_transacoes
              FROM p_transaction t
             INNER JOIN p_account a
            ON t.account_id = a.account_id
             INNER JOIN p_wallet w
            ON a.wallet_id = w.wallet_id
             INNER JOIN p_transaction_category tc
            ON t.transaction_id = tc.transaction_id
             INNER JOIN p_category c
            ON tc.category_id = c.category_id
             WHERE w.user_id = r_orcamento.user_id
               AND t.transaction_date BETWEEN r_orcamento.start_date AND least(
                p_data_referencia,
                r_orcamento.end_date
            )
               AND t.has_occurred = 1
               AND c.type = 'expense';
        END IF;

        v_percentual_usado :=
            CASE
                WHEN r_orcamento.limit_value > 0 THEN
                    round(
                        (v_total_gasto / r_orcamento.limit_value) * 100,
                        2
                    )
                ELSE
                    0
            END;

        v_saldo_disponivel := r_orcamento.limit_value - v_total_gasto;
        v_gasto_medio_dia :=
            CASE
                WHEN v_dias_decorridos > 0 THEN
                    round(
                        v_total_gasto / v_dias_decorridos,
                        2
                    )
                ELSE
                    0
            END;

        v_projecao_final :=
            CASE
                WHEN v_dias_decorridos > 0 THEN
                    round(
                        v_gasto_medio_dia * v_dias_periodo,
                        2
                    )
                ELSE
                    v_total_gasto
            END;

        IF v_percentual_usado >= 100 THEN
            v_status_orcamento := 'ESTOURADO';
            v_nivel_alerta := 'CRÍTICO';
        ELSIF v_percentual_usado >= 90 THEN
            v_status_orcamento := 'QUASE ESGOTADO';
            v_nivel_alerta := 'ALTO';
        ELSIF v_percentual_usado >= 75 THEN
            v_status_orcamento := 'EM ALERTA';
            v_nivel_alerta := 'MÉDIO';
        ELSIF v_percentual_usado >= 50 THEN
            v_status_orcamento := 'MONITORAR';
            v_nivel_alerta := 'BAIXO';
        ELSE
            v_status_orcamento := 'SAUDÁVEL';
            v_nivel_alerta := 'NORMAL';
        END IF;

        IF
            v_projecao_final > r_orcamento.limit_value
            AND v_status_orcamento = 'SAUDÁVEL'
        THEN
            v_status_orcamento := 'RISCO FUTURO';
            v_nivel_alerta := 'MÉDIO';
        END IF;

        v_linha := tp_analise_orcamento(
            r_orcamento.full_name,
            r_orcamento.email,
            nvl(
                r_orcamento.budget_name,
                'Orçamento Geral'
            ),
            nvl(
                r_orcamento.category_name,
                'TODAS'
            ),
            nvl(
                r_orcamento.category_type,
                'N/A'
            ),
            r_orcamento.start_date,
            r_orcamento.end_date,
            v_dias_periodo,
            r_orcamento.limit_value,
            v_total_gasto,
            v_percentual_usado,
            v_saldo_disponivel,
            v_qtd_transacoes,
            v_gasto_medio_dia,
            v_projecao_final,
            v_status_orcamento,
            v_nivel_alerta
        );

        PIPE ROW ( v_linha );
    END LOOP;

    RETURN;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20002,
            'Erro ao gerar análise de orçamento: ' || sqlerrm
        );
END fn_analise_orcamento;
/

   SET LINESIZE 200
SET PAGESIZE 100
SET WRAP OFF

COLUMN usuario FORMAT A20 HEADING "Usuario"
COLUMN email FORMAT A25 HEADING "Email"
COLUMN nome_orcamento FORMAT A18 HEADING "Orcamento"
COLUMN categoria FORMAT A15 HEADING "Categoria"
COLUMN tipo_categoria FORMAT A8 HEADING "Tipo"
COLUMN periodo_inicio FORMAT A10 HEADING "Inicio"
COLUMN periodo_fim FORMAT A10 HEADING "Fim"
COLUMN dias_periodo FORMAT 999 HEADING "Dias"
COLUMN limite_orcamento FORMAT 99,999.99 HEADING "Limite"
COLUMN total_gasto FORMAT 99,999.99 HEADING "Gasto"
COLUMN percentual_usado FORMAT 990.99 HEADING "% Uso"
COLUMN saldo_disponivel FORMAT 99,999.99 HEADING "Saldo"
COLUMN qtd_transacoes FORMAT 999 HEADING "Qtd"
COLUMN gasto_medio_dia FORMAT 9,999.99 HEADING "Media/Dia"
COLUMN projecao_final FORMAT 99,999.99 HEADING "Projecao"
COLUMN status_orcamento FORMAT A14 HEADING "Status"
COLUMN nivel_alerta FORMAT A8 HEADING "Alerta"

SELECT *
  FROM TABLE ( fn_analise_orcamento() );

SELECT *
  FROM TABLE ( fn_analise_orcamento(p_user_id => 1) );

SELECT *
  FROM TABLE ( fn_analise_orcamento(
    p_user_id         => 1,
    p_data_referencia => TO_DATE('2025-06-15',
                     'YYYY-MM-DD')
) );

SELECT usuario,
       nome_orcamento,
       categoria,
       to_char(
           limite_orcamento,
           'L999G999G990D00'
       ) AS limite,
       to_char(
           total_gasto,
           'L999G999G990D00'
       ) AS gasto,
       percentual_usado || '%' AS perc_usado,
       to_char(
           saldo_disponivel,
           'L999G999G990D00'
       ) AS saldo,
       status_orcamento,
       nivel_alerta
  FROM TABLE ( fn_analise_orcamento() )
 WHERE nivel_alerta IN ( 'ALTO',
                         'CRÍTICO' )
 ORDER BY percentual_usado DESC;

SELECT nivel_alerta,
       COUNT(*) AS qtd_orcamentos,
       SUM(limite_orcamento) AS total_limite,
       SUM(total_gasto) AS total_gasto,
       round(
           avg(percentual_usado),
           2
       ) AS media_percentual,
       SUM(qtd_transacoes) AS total_transacoes
  FROM TABLE ( fn_analise_orcamento() )
 GROUP BY nivel_alerta
 ORDER BY
    CASE nivel_alerta
        WHEN 'CRÍTICO' THEN
            1
        WHEN 'ALTO'    THEN
            2
        WHEN 'MÉDIO'   THEN
            3
        WHEN 'BAIXO'   THEN
            4
        WHEN 'NORMAL'  THEN
            5
    END;

SELECT usuario,
       COUNT(*) AS total_orcamentos,
       SUM(
           CASE
               WHEN status_orcamento = 'ESTOURADO' THEN
                   1
               ELSE
                   0
           END
       ) AS estourados,
       SUM(
           CASE
               WHEN status_orcamento IN('QUASE ESGOTADO',
                                        'EM ALERTA') THEN
                   1
               ELSE
                   0
           END
       ) AS em_alerta,
       SUM(limite_orcamento) AS limite_total,
       SUM(total_gasto) AS gasto_total,
       round(
           avg(percentual_usado),
           2
       ) AS media_uso_percentual
  FROM TABLE ( fn_analise_orcamento() )
 GROUP BY usuario
HAVING SUM(
    CASE
        WHEN status_orcamento = 'ESTOURADO' THEN
            1
        ELSE
            0
    END
) > 0
 ORDER BY estourados DESC,
          gasto_total DESC;