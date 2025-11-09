   SET SERVEROUTPUT ON;

-- Tabela State
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_state (
    p_name         IN p_state.name%TYPE,
    p_abbreviation IN p_state.abbreviation%TYPE
) AS
BEGIN
    INSERT INTO p_state (
        state_id,
        name,
        abbreviation
    ) VALUES ( seq_state.NEXTVAL,
               p_name,
               p_abbreviation );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        ROLLBACK;
        raise_application_error(
            -20001,
            'Já existe um estado com esse nome ou sigla.'
        );
    WHEN OTHERS THEN
        ROLLBACK;
        raise_application_error(
            -20002,
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
            -20003,
            'Nenhum estado encontrado com o ID informado.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -20004,
            'Já existe um estado com esse nome ou sigla.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -20005,
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
            -20006,
            'Nenhum estado encontrado com o ID informado.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20007,
            'Erro ao remover estado: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Teste


--INSERT
BEGIN
    pr_insert_state(
        'Acre',
        'AC'
    );
END;
/
--UPDATE
DECLARE
    v_id p_state.state_id%TYPE;
BEGIN
    SELECT state_id
      INTO v_id
      FROM p_state
     WHERE name = 'Acre';
    pr_update_state(
        v_id,
        'TESTE_Rio Janeiro',
        'JJ'
    );
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
END;
/


SELECT *
  FROM p_state;