   SET SERVEROUTPUT ON;

-- Tabela Account Type
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_account_type (
    p_name     IN p_account_type.name%TYPE,
    p_label    IN p_account_type.label%TYPE,
    p_behavior IN p_account_type.behavior%TYPE
) AS
BEGIN
    INSERT INTO p_account_type (
        name,
        label,
        behavior
    ) VALUES ( p_name,
               p_label,
               p_behavior );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -20020,
            'Já existe um tipo de conta com esse nome ou label.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -20021,
            'Erro ao inserir tipo de conta: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Update
CREATE OR REPLACE PROCEDURE pr_update_account_type (
    p_account_type_id IN p_account_type.account_type_id%TYPE,
    p_name            IN p_account_type.name%TYPE,
    p_label           IN p_account_type.label%TYPE,
    p_behavior        IN p_account_type.behavior%TYPE
) AS
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO v_exists
      FROM p_account_type
     WHERE account_type_id = p_account_type_id;

    IF v_exists = 0 THEN
        raise_application_error(
            -20022,
            'Tipo de conta não encontrado para atualização.'
        );
    END IF;
    UPDATE p_account_type
       SET name = p_name,
           label = p_label,
           behavior = p_behavior
     WHERE account_type_id = p_account_type_id;

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -20023,
            'Já existe um tipo de conta com esse nome ou label.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -20024,
            'Erro ao atualizar tipo de conta: ' || sqlerrm
        );
END;
/




-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_account_type (
    p_account_type_id IN p_account_type.account_type_id%TYPE
) AS
BEGIN
    DELETE FROM p_account_type
     WHERE account_type_id = p_account_type_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20025,
            'Tipo de conta não encontrado para remoção.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20026,
            'Erro ao remover tipo de conta: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Teste

--INSERT
BEGIN
    pr_insert_account_type(
        'TESTE_Corrente',
        'Conta TESTE',
        'wallet'
    );
END;
/
--UPDATE
DECLARE
    v_id p_account_type.account_type_id%TYPE;
BEGIN
    SELECT account_type_id
      INTO v_id
      FROM p_account_type
     WHERE name = 'TESTE_Corrente';
    pr_update_account_type(
        v_id,
        'TESTE_Poupança',
        'Poupança',
        'wallet'
    );
END;
/
--DELETE
DECLARE
    v_id p_account_type.account_type_id%TYPE;
BEGIN
    SELECT account_type_id
      INTO v_id
      FROM p_account_type
     WHERE name = 'TESTE_Poupança';
    pr_delete_account_type(v_id);
END;
/

SELECT *
  FROM p_account_type;