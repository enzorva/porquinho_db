CREATE OR REPLACE TYPE tp_relatorio_financeiro AS OBJECT (
        usuario           VARCHAR2(200),
        email             VARCHAR2(255),
        carteira          VARCHAR2(50),
        conta             VARCHAR2(50),
        tipo_conta        VARCHAR2(50),
        banco             VARCHAR2(100),
        saldo_atual       NUMBER(
            14,
            2
        ),
        total_receitas    NUMBER(
            14,
            2
        ),
        total_despesas    NUMBER(
            14,
            2
        ),
        saldo_liquido     NUMBER(
            14,
            2
        ),
        qtd_transacoes    NUMBER,
        status_financeiro VARCHAR2(20)
);
/

CREATE OR REPLACE TYPE tb_relatorio_financeiro AS
    TABLE OF tp_relatorio_financeiro;
/

CREATE OR REPLACE FUNCTION fn_relatorio_financeiro_usuario (
    p_user_id     IN NUMBER DEFAULT NULL,
    p_data_inicio IN DATE DEFAULT NULL,
    p_data_fim    IN DATE DEFAULT NULL
) RETURN tb_relatorio_financeiro
    PIPELINED
IS
    CURSOR c_relatorio IS
    SELECT u.full_name,
           u.email,
           w.name AS wallet_name,
           a.name AS account_name,
           at.label AS account_type,
           b.name AS bank_name,
           a.balance,
           u.user_id,
           a.account_id
      FROM p_user u
     INNER JOIN p_wallet w
    ON u.user_id = w.user_id
     INNER JOIN p_account a
    ON w.wallet_id = a.wallet_id
     INNER JOIN p_account_type at
    ON a.account_type_id = at.account_type_id
      LEFT JOIN p_bank b
    ON a.bank_id = b.bank_id
     WHERE ( p_user_id IS NULL
        OR u.user_id = p_user_id )
     ORDER BY u.full_name,
              w.name,
              a.name;

    v_total_receitas    NUMBER(
        14,
        2
    );
    v_total_despesas    NUMBER(
        14,
        2
    );
    v_qtd_transacoes    NUMBER;
    v_saldo_liquido     NUMBER(
        14,
        2
    );
    v_status_financeiro VARCHAR2(20);
    v_linha             tp_relatorio_financeiro;
BEGIN
    FOR r_conta IN c_relatorio LOOP
        SELECT nvl(
            sum(t.transaction_value),
            0
        )
          INTO v_total_receitas
          FROM p_transaction t
         INNER JOIN p_transaction_category tc
        ON t.transaction_id = tc.transaction_id
         INNER JOIN p_category c
        ON tc.category_id = c.category_id
         WHERE t.account_id = r_conta.account_id
           AND c.type = 'recipe'
           AND t.has_occurred = 1
           AND ( p_data_inicio IS NULL
            OR t.transaction_date >= p_data_inicio )
           AND ( p_data_fim IS NULL
            OR t.transaction_date <= p_data_fim );

        SELECT nvl(
            sum(t.transaction_value),
            0
        )
          INTO v_total_despesas
          FROM p_transaction t
         INNER JOIN p_transaction_category tc
        ON t.transaction_id = tc.transaction_id
         INNER JOIN p_category c
        ON tc.category_id = c.category_id
         WHERE t.account_id = r_conta.account_id
           AND c.type = 'expense'
           AND t.has_occurred = 1
           AND ( p_data_inicio IS NULL
            OR t.transaction_date >= p_data_inicio )
           AND ( p_data_fim IS NULL
            OR t.transaction_date <= p_data_fim );

        SELECT COUNT(*)
          INTO v_qtd_transacoes
          FROM p_transaction t
         WHERE t.account_id = r_conta.account_id
           AND t.has_occurred = 1
           AND ( p_data_inicio IS NULL
            OR t.transaction_date >= p_data_inicio )
           AND ( p_data_fim IS NULL
            OR t.transaction_date <= p_data_fim );

        v_saldo_liquido := v_total_receitas - v_total_despesas;
        IF v_saldo_liquido > 0 THEN
            v_status_financeiro := 'POSITIVO';
        ELSIF v_saldo_liquido < 0 THEN
            v_status_financeiro := 'NEGATIVO';
        ELSE
            v_status_financeiro := 'NEUTRO';
        END IF;

        v_linha := tp_relatorio_financeiro(
            r_conta.full_name,
            r_conta.email,
            r_conta.wallet_name,
            r_conta.account_name,
            r_conta.account_type,
            nvl(
                r_conta.bank_name,
                'N/A'
            ),
            r_conta.balance,
            v_total_receitas,
            v_total_despesas,
            v_saldo_liquido,
            v_qtd_transacoes,
            v_status_financeiro
        );

        PIPE ROW ( v_linha );
    END LOOP;

    RETURN;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20001,
            'Erro ao gerar relatório: ' || sqlerrm
        );
END fn_relatorio_financeiro_usuario;
/

   SET LINESIZE 200
SET PAGESIZE 50

COLUMN usuario FORMAT A30
COLUMN email FORMAT A35
COLUMN carteira FORMAT A25
COLUMN conta FORMAT A25
COLUMN tipo_conta FORMAT A20
COLUMN banco FORMAT A20
COLUMN saldo_atual FORMAT 999,999.99
COLUMN total_receitas FORMAT 999,999.99
COLUMN total_despesas FORMAT 999,999.99
COLUMN saldo_liquido FORMAT 999,999.99
COLUMN qtd_transacoes FORMAT 999
COLUMN status_financeiro FORMAT A10


SELECT usuario,
       email,
       COUNT(*) AS total_contas,
       SUM(saldo_atual) AS saldo_total,
       SUM(total_receitas) AS receitas_totais,
       SUM(total_despesas) AS despesas_totais,
       SUM(saldo_liquido) AS saldo_liquido_total
  FROM TABLE ( fn_relatorio_financeiro_usuario() )
 GROUP BY usuario,
          email
 ORDER BY saldo_liquido_total DESC;