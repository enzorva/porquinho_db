   SET SERVEROUTPUT ON;

-- Tabela Budget
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_budget (
    p_user_id     IN p_budget.user_id%TYPE,
    p_name        IN p_budget.name%TYPE,
    p_category_id IN p_budget.category_id%TYPE,
    p_start_date  IN p_budget.start_date%TYPE,
    p_end_date    IN p_budget.end_date%TYPE,
    p_limit_value IN p_budget.limit_value%TYPE
) AS
BEGIN
    INSERT INTO p_budget (
        user_id,
        name,
        category_id,
        start_date,
        end_date,
        limit_value
    ) VALUES ( p_user_id,
               p_name,
               p_category_id,
               p_start_date,
               p_end_date,
               p_limit_value );

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20501,
            'Erro ao inserir orçamento: ' || sqlerrm
        );
END;


-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE pr_update_budget (
    p_budget_id   IN p_budget.budget_id%TYPE,
    p_user_id     IN p_budget.user_id%TYPE,
    p_name        IN p_budget.name%TYPE,
    p_category_id IN p_budget.category_id%TYPE,
    p_start_date  IN p_budget.start_date%TYPE,
    p_end_date    IN p_budget.end_date%TYPE,
    p_limit_value IN p_budget.limit_value%TYPE
) AS
BEGIN
    UPDATE p_budget
       SET user_id = p_user_id,
           name = p_name,
           category_id = p_category_id,
           start_date = p_start_date,
           end_date = p_end_date,
           limit_value = p_limit_value,
           updated_at = systimestamp
     WHERE budget_id = p_budget_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20502,
            'Orçamento não encontrado para atualização.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20503,
            'Erro ao atualizar orçamento: ' || sqlerrm
        );
END;
/



-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_budget (
    p_budget_id IN p_budget.budget_id%TYPE
) AS
BEGIN
    DELETE FROM p_budget
     WHERE budget_id = p_budget_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20504,
            'Orçamento não encontrado para exclusão.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20505,
            'Erro ao excluir orçamento: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Teste


-- INSERT
BEGIN
    pr_insert_budget(
        1,
        'TESTE_Alimentação Mensal',
        1,
        DATE '2025-11-01',
        DATE '2025-11-30',
        1500
    );
END;
/
-- UPDATE
DECLARE
    v_id p_budget.budget_id%TYPE;
BEGIN
    SELECT budget_id
      INTO v_id
      FROM p_budget
     WHERE name = 'TESTE_Alimentação Mensal';
    pr_update_budget(
        v_id,
        1,
        'TESTE_Transporte Dezembro',
        2,
        DATE '2025-12-01',
        DATE '2025-12-31',
        800
    );
END;
/
-- DELETE
DECLARE
    v_id p_budget.budget_id%TYPE;
BEGIN
    SELECT budget_id
      INTO v_id
      FROM p_budget
     WHERE name = 'TESTE_Transporte Dezembro';
    pr_delete_budget(v_id);
END;
/

SELECT *
  FROM p_budget;