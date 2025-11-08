   SET SERVEROUTPUT ON;

-- Tabela Time Zone
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_finance_objective (
    p_name IN p_finance_objective.name%TYPE
) AS
BEGIN
    INSERT INTO p_finance_objective ( name ) VALUES ( p_name );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -21001,
            'Já existe um objetivo financeiro com esse nome.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -21002,
            'Erro ao inserir objetivo financeiro: ' || sqlerrm
        );
END;
/





-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE pr_update_finance_objective (
    p_finance_objective_id IN p_finance_objective.finance_objective_id%TYPE,
    p_name                 IN p_finance_objective.name%TYPE
) AS
BEGIN
    UPDATE p_finance_objective
       SET
        name = p_name
     WHERE finance_objective_id = p_finance_objective_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -21003,
            'Nenhum objetivo financeiro encontrado com o ID informado.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -21004,
            'Já existe um objetivo financeiro com esse nome.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -21005,
            'Erro ao atualizar objetivo financeiro: ' || sqlerrm
        );
END;
/





-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_finance_objective (
    p_finance_objective_id IN p_finance_objective.finance_objective_id%TYPE
) AS
BEGIN
    DELETE FROM p_finance_objective
     WHERE finance_objective_id = p_finance_objective_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -21006,
            'Nenhum objetivo financeiro encontrado com o ID informado.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -21007,
            'Erro ao remover objetivo financeiro: ' || sqlerrm
        );
END;
/




-- ======================================================================

-- Teste

-- INSERT
BEGIN
    pr_insert_finance_objective('TESTE_Casa');
    dbms_output.put_line('1 OK');
END;
/
-- UPDATE
DECLARE
    v_id p_finance_objective.finance_objective_id%TYPE;
BEGIN
    SELECT finance_objective_id
      INTO v_id
      FROM p_finance_objective
     WHERE name = 'TESTE_Casa';
    pr_update_finance_objective(
        v_id,
        'TESTE_Aposentadoria'
    );
END;
/
-- DELETE
DECLARE
    v_id p_finance_objective.finance_objective_id%TYPE;
BEGIN
    SELECT finance_objective_id
      INTO v_id
      FROM p_finance_objective
     WHERE name = 'TESTE_Aposentadoria';
    pr_delete_finance_objective(v_id);
END;