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
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('1 ERRO');
END;
/
BEGIN
    pr_insert_finance_objective('TESTE_Casa');
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -21001 THEN
            dbms_output.put_line('2 OK');
        ELSE
            dbms_output.put_line('2 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_finance_objective(NULL);
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -21002 THEN
            dbms_output.put_line('3 OK');
        ELSE
            dbms_output.put_line('3 ERRO');
        END IF;
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
    dbms_output.put_line('4 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('4 ERRO');
END;
/
BEGIN
    pr_update_finance_objective(
        0,
        'X'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -21003 THEN
            dbms_output.put_line('5 OK');
        ELSE
            dbms_output.put_line('5 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_finance_objective('TESTE_Viagem');
    SELECT finance_objective_id
      INTO v_id
      FROM p_finance_objective
     WHERE name = 'TESTE_Aposentadoria';
    pr_update_finance_objective(
        v_id,
        'TESTE_Viagem'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -21004 THEN
            dbms_output.put_line('6 OK');
        ELSE
            dbms_output.put_line('6 ERRO');
        END IF;
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
    dbms_output.put_line('7 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('7 ERRO');
END;
/
BEGIN
    pr_delete_finance_objective(0);
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -21006 THEN
            dbms_output.put_line('8 OK');
        ELSE
            dbms_output.put_line('8 ERRO');
        END IF;
END;
/