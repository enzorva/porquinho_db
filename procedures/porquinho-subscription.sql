-- Tabela Subscription
-- Insert

CREATE OR REPLACE PROCEDURE sp_insert_subscription (
    p_user_id                IN p_subscription.user_id%TYPE,
    p_subscription_tier_id   IN p_subscription.subscription_tier_id%TYPE,
    p_subscription_status_id IN p_subscription.subscription_status_id%TYPE,
    p_end_date               IN p_subscription.end_date%TYPE DEFAULT NULL
) AS
BEGIN
    INSERT INTO p_subscription (
        user_id,
        subscription_tier_id,
        subscription_status_id,
        end_date
    ) VALUES ( p_user_id,
               p_subscription_tier_id,
               p_subscription_status_id,
               p_end_date );

    dbms_output.put_line('Assinatura criada com sucesso.');
EXCEPTION
    WHEN dup_val_on_index THEN
        dbms_output.put_line('Erro: Assinatura duplicada.');
    WHEN OTHERS THEN
        dbms_output.put_line('Erro inesperado ao inserir assinatura: ' || sqlerrm);
END;


-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE sp_update_subscription (
    p_subscription_id        IN p_subscription.subscription_id%TYPE,
    p_subscription_tier_id   IN p_subscription.subscription_tier_id%TYPE,
    p_subscription_status_id IN p_subscription.subscription_status_id%TYPE,
    p_end_date               IN p_subscription.end_date%TYPE
) AS
BEGIN
    UPDATE p_subscription
       SET subscription_tier_id = p_subscription_tier_id,
           subscription_status_id = p_subscription_status_id,
           end_date = p_end_date,
           updated_at = systimestamp
     WHERE subscription_id = p_subscription_id;

    IF SQL%rowcount = 0 THEN
        dbms_output.put_line('Nenhuma assinatura encontrada para atualização.');
    ELSE
        dbms_output.put_line('Assinatura atualizada com sucesso.');
    END IF;
EXCEPTION
    WHEN dup_val_on_index THEN
        dbms_output.put_line('Erro: Conflito de chave única ao atualizar assinatura.');
    WHEN OTHERS THEN
        dbms_output.put_line('Erro inesperado ao atualizar assinatura: ' || sqlerrm);
END;


-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE sp_delete_subscription (
    p_subscription_id IN p_subscription.subscription_id%TYPE
) AS
BEGIN
    DELETE FROM p_subscription
     WHERE subscription_id = p_subscription_id;

    IF SQL%rowcount = 0 THEN
        dbms_output.put_line('Nenhuma assinatura encontrada para remoção.');
    ELSE
        dbms_output.put_line('Assinatura removida com sucesso.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Erro ao remover assinatura: ' || sqlerrm);
END;
/
-- ======================================================================

-- Teste

--INSERT
BEGIN
    sp_insert_subscription(
        1,
        1,
        1,
        DATE '2026-11-06'
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
BEGIN
    sp_insert_subscription(
        1,
        1,
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
BEGIN
    sp_insert_subscription(
        99999,
        1,
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
--UPDATE
DECLARE
    v_id p_subscription.subscription_id%TYPE;
BEGIN
    SELECT subscription_id
      INTO v_id
      FROM p_subscription
     WHERE user_id = 1;
    sp_update_subscription(
        v_id,
        1,
        1,
        DATE '2026-12-31'
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
BEGIN
    sp_update_subscription(
        999999,
        1,
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
--DELETE
DECLARE
    v_id p_subscription.subscription_id%TYPE;
BEGIN
    SELECT subscription_id
      INTO v_id
      FROM p_subscription
     WHERE user_id = 1;
    sp_delete_subscription(v_id);
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
BEGIN
    sp_delete_subscription(999999);
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/