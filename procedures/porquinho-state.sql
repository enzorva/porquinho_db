-- Tabela State
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_state (
    p_name         IN p_state.name%TYPE,
    p_abbreviation IN p_state.abbreviation%TYPE
) AS
BEGIN
    INSERT INTO p_state (
        name,
        abbreviation
    ) VALUES ( p_name,
               p_abbreviation );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -23001,
            'Já existe um estado com esse nome ou sigla.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -23002,
            'Erro ao inserir estado: ' || sqlerrm
        );
END;
/

-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE pr_update_state (
    p_state_id     IN p_state.state_id%TYPE,
    p_name         IN p_state.name%TYPE,
    p_abbreviation IN p_state.abbreviation%TYPE
) AS
BEGIN
    UPDATE p_state
       SET name = p_name,
           abbreviation = p_abbreviation
     WHERE state_id = p_state_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -23003,
            'Nenhum estado encontrado com o ID informado.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -23004,
            'Já existe um estado com esse nome ou sigla.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -23005,
            'Erro ao atualizar estado: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_state (
    p_state_id IN p_state.state_id%TYPE
) AS
BEGIN
    DELETE FROM p_state
     WHERE state_id = p_state_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -23006,
            'Nenhum estado encontrado com o ID informado.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -23007,
            'Erro ao remover estado: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Teste


--INSERT
BEGIN
    pr_insert_state(
        'TESTE_São Paulo',
        'SP'
    );
    dbms_output.put_line('1 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('1 ERRO');
END;
/
BEGIN
    pr_insert_state(
        'TESTE_São Paulo',
        'XX'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -23001 THEN
            dbms_output.put_line('2 OK');
        ELSE
            dbms_output.put_line('2 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_state(
        NULL,
        'YY'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -23002 THEN
            dbms_output.put_line('3 OK');
        ELSE
            dbms_output.put_line('3 ERRO');
        END IF;
END;
/
--UPDATE
DECLARE
    v_id p_state.state_id%TYPE;
BEGIN
    SELECT state_id
      INTO v_id
      FROM p_state
     WHERE name = 'TESTE_São Paulo';
    pr_update_state(
        v_id,
        'TESTE_Rio Janeiro',
        'RJ'
    );
    dbms_output.put_line('4 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('4 ERRO');
END;
/
BEGIN
    pr_update_state(
        0,
        'X',
        'Y'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -23003 THEN
            dbms_output.put_line('5 OK');
        ELSE
            dbms_output.put_line('5 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_state(
        'TESTE_Minas Gerais',
        'MG'
    );
    SELECT state_id
      INTO v_id
      FROM p_state
     WHERE name = 'TESTE_Rio Janeiro';
    pr_update_state(
        v_id,
        'TESTE_Minas Gerais',
        'XX'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -23004 THEN
            dbms_output.put_line('6 OK');
        ELSE
            dbms_output.put_line('6 ERRO');
        END IF;
END;
/
--DELETE
DECLARE
    v_id p_state.state_id%TYPE;
BEGIN
    SELECT state_id
      INTO v_id
      FROM p_state
     WHERE name = 'TESTE_Rio Janeiro';
    pr_delete_state(v_id);
    dbms_output.put_line('7 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('7 ERRO');
END;
/
BEGIN
    pr_delete_state(0);
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -23006 THEN
            dbms_output.put_line('8 OK');
        ELSE
            dbms_output.put_line('8 ERRO');
        END IF;
END;
/