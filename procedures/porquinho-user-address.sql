   SET SERVEROUTPUT ON;

-- Tabela User Address
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_user_address (
    p_user_id IN p_user_address.user_id%TYPE,
    p_cep     IN p_user_address.cep%TYPE,
    p_city_id IN p_user_address.city_id%TYPE
) AS
BEGIN
    INSERT INTO p_user_address (
        user_id,
        cep,
        city_id
    ) VALUES ( p_user_id,
               p_cep,
               p_city_id );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -20001,
            'Este usuário já possui um endereço cadastrado.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -20002,
            'Erro ao inserir endereço do usuário: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE pr_update_user_address (
    p_user_address_id IN p_user_address.user_address_id%TYPE,
    p_user_id         IN p_user_address.user_id%TYPE,
    p_cep             IN p_user_address.cep%TYPE,
    p_city_id         IN p_user_address.city_id%TYPE
) AS
BEGIN
    UPDATE p_user_address
       SET user_id = p_user_id,
           cep = p_cep,
           city_id = p_city_id,
           updated_at = systimestamp
     WHERE user_address_id = p_user_address_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20003,
            'Endereço não encontrado para atualização.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -20004,
            'Este usuário já possui outro endereço cadastrado.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -20005,
            'Erro ao atualizar endereço do usuário: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_user_address (
    p_user_address_id IN p_user_address.user_address_id%TYPE
) AS
BEGIN
    DELETE FROM p_user_address
     WHERE user_address_id = p_user_address_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20006,
            'Endereço não encontrado para remoção.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20007,
            'Erro ao remover endereço do usuário: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Teste

--INSERT
BEGIN
    pr_insert_user_address(
        11,
        01041 - 609,
        5
    );
END;
/

--UPDATE
DECLARE
    v_id p_user_address.user_address_id%TYPE;
BEGIN
    SELECT user_address_id
      INTO v_id
      FROM p_user_address
     WHERE cep = 01041 - 609;
    pr_update_user_address(
        v_id,
        11,
        20000 - 000,
        2
    );
END;
/
--DELETE
DECLARE
    v_id p_user_address.user_address_id%TYPE;
BEGIN
    SELECT user_address_id
      INTO v_id
      FROM p_user_address
     WHERE cep = 20000 - 000;
    pr_delete_user_address(v_id);
END;
/
BEGIN
    pr_delete_user_address(0);
END;
/


SELECT *
  FROM p_user_address;