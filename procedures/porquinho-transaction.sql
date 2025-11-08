   SET SERVEROUTPUT ON;

-- Tabela Transaction
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_transaction (
    p_value               IN p_transaction.value%TYPE,
    p_description         IN p_transaction.description%TYPE,
    p_transaction_date    IN p_transaction.transaction_date%TYPE DEFAULT sysdate,
    p_has_occurred        IN p_transaction.has_occurred%TYPE DEFAULT 1,
    p_is_auto_confirmed   IN p_transaction.is_auto_confirmed%TYPE DEFAULT 0,
    p_observation         IN p_transaction.observation%TYPE,
    p_account_id          IN p_transaction.account_id%TYPE,
    p_transaction_icon_id IN p_transaction.transaction_icon_id%TYPE,
    p_color_id            IN p_transaction.color_id%TYPE
) AS
    v_validation_result VARCHAR2(200);
BEGIN
    v_validation_result := fn_validate_transaction(
        p_account_id,
        p_value,
        p_transaction_icon_id,
        p_color_id
    );
    IF v_validation_result <> 'VÁLIDO' THEN
        raise_application_error(
            -20100,
            v_validation_result
        );
    END IF;
    INSERT INTO p_transaction (
        value,
        description,
        transaction_date,
        has_occurred,
        is_auto_confirmed,
        observation,
        account_id,
        transaction_icon_id,
        color_id
    ) VALUES ( p_value,
               p_description,
               p_transaction_date,
               p_has_occurred,
               p_is_auto_confirmed,
               p_observation,
               p_account_id,
               p_transaction_icon_id,
               p_color_id );

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20101,
            'Erro ao inserir transação: ' || sqlerrm
        );
END;


-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE pr_update_transaction (
    p_transaction_id      IN p_transaction.transaction_id%TYPE,
    p_value               IN p_transaction.value%TYPE,
    p_description         IN p_transaction.description%TYPE,
    p_transaction_date    IN p_transaction.transaction_date%TYPE,
    p_has_occurred        IN p_transaction.has_occurred%TYPE,
    p_is_auto_confirmed   IN p_transaction.is_auto_confirmed%TYPE,
    p_observation         IN p_transaction.observation%TYPE,
    p_account_id          IN p_transaction.account_id%TYPE,
    p_transaction_icon_id IN p_transaction.transaction_icon_id%TYPE,
    p_color_id            IN p_transaction.color_id%TYPE
) AS
    v_validation_result VARCHAR2(200);
BEGIN
    v_validation_result := fn_validate_transaction(
        p_account_id,
        p_value,
        p_transaction_icon_id,
        p_color_id
    );
    IF v_validation_result <> 'VÁLIDO' THEN
        raise_application_error(
            -20100,
            v_validation_result
        );
    END IF;
    UPDATE p_transaction
       SET value = p_value,
           description = p_description,
           transaction_date = p_transaction_date,
           has_occurred = p_has_occurred,
           is_auto_confirmed = p_is_auto_confirmed,
           observation = p_observation,
           account_id = p_account_id,
           transaction_icon_id = p_transaction_icon_id,
           color_id = p_color_id,
           updated_at = systimestamp
     WHERE transaction_id = p_transaction_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20102,
            'Transação não encontrada para atualização.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20103,
            'Erro ao atualizar transação: ' || sqlerrm
        );
END;


-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_transaction (
    p_transaction_id IN p_transaction.transaction_id%TYPE
) AS
BEGIN
    DELETE FROM p_transaction
     WHERE transaction_id = p_transaction_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20104,
            'Transação não encontrada para exclusão.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20105,
            'Erro ao excluir transação: ' || sqlerrm
        );
END;
/




-- ======================================================================

-- Teste

--INSERT
BEGIN
    pr_insert_transaction(
        p_value               => 89.90,
        p_description         => 'TESTE_Supermercado',
        p_account_id          => 1,
        p_transaction_icon_id => 1,
        p_color_id            => 1
    );
END;
/
--UPDATE
DECLARE
    v_id p_transaction.transaction_id%TYPE;
BEGIN
    SELECT transaction_id
      INTO v_id
      FROM p_transaction
     WHERE description = 'TESTE_Supermercado';
    pr_update_transaction(
        p_transaction_id      => v_id,
        p_value               => 95.50,
        p_description         => 'TESTE_Supermercado Atualizado',
        p_account_id          => 1,
        p_transaction_icon_id => 1,
        p_color_id            => 1
    );
END;
/
--DELETE
DECLARE
    v_id p_transaction.transaction_id%TYPE;
BEGIN
    SELECT transaction_id
      INTO v_id
      FROM p_transaction
     WHERE description = 'TESTE_Supermercado Atualizado';
    pr_delete_transaction(v_id);
END;
/