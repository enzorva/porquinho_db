   SET SERVEROUTPUT ON;

-- Tabela Subscription Tier
-- Insert

CREATE OR REPLACE PROCEDURE sp_insert_subscription_tier (
    p_name        IN p_subscription_tier.name%TYPE,
    p_description IN p_subscription_tier.description%TYPE,
    p_price       IN p_subscription_tier.price%TYPE
) AS
BEGIN
    INSERT INTO p_subscription_tier (
        name,
        description,
        price
    ) VALUES ( p_name,
               p_description,
               p_price );

    dbms_output.put_line('Subscription tier inserted successfully.');
EXCEPTION
    WHEN dup_val_on_index THEN
        dbms_output.put_line('Error: A subscription tier with this name already exists.');
    WHEN OTHERS THEN
        dbms_output.put_line('Unexpected error: ' || sqlerrm);
END;


-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE sp_update_subscription_tier (
    p_subscription_tier_id IN p_subscription_tier.subscription_tier_id%TYPE,
    p_name                 IN p_subscription_tier.name%TYPE,
    p_description          IN p_subscription_tier.description%TYPE,
    p_price                IN p_subscription_tier.price%TYPE
) AS
BEGIN
    UPDATE p_subscription_tier
       SET name = p_name,
           description = p_description,
           price = p_price
     WHERE subscription_tier_id = p_subscription_tier_id;

    IF SQL%rowcount = 0 THEN
        dbms_output.put_line('No subscription tier found with the provided ID.');
    ELSE
        dbms_output.put_line('Subscription tier updated successfully.');
    END IF;
EXCEPTION
    WHEN dup_val_on_index THEN
        dbms_output.put_line('Error: A subscription tier with this name already exists.');
    WHEN OTHERS THEN
        dbms_output.put_line('Unexpected error: ' || sqlerrm);
END;


-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE sp_delete_subscription_tier (
    p_subscription_tier_id IN p_subscription_tier.subscription_tier_id%TYPE
) AS
BEGIN
    DELETE FROM p_subscription_tier
     WHERE subscription_tier_id = p_subscription_tier_id;

    IF SQL%rowcount = 0 THEN
        dbms_output.put_line('No subscription tier found with the provided ID.');
    ELSE
        dbms_output.put_line('Subscription tier deleted successfully.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Unexpected error: ' || sqlerrm);
END;


-- ======================================================================

-- Teste

-- INSERT
BEGIN
    sp_insert_subscription_tier(
        'TESTE_Básico',
        'Plano mensal básico',
        29.90
    );
END;
/
--UPDATE
DECLARE
    v_id p_subscription_tier.subscription_tier_id%TYPE;
BEGIN
    SELECT subscription_tier_id
      INTO v_id
      FROM p_subscription_tier
     WHERE name = 'TESTE_Básico';
    sp_update_subscription_tier(
        v_id,
        'TESTE_Premium',
        'Plano anual com descontos',
        299.90
    );
END;
/

--DELETE
DECLARE
    v_id p_subscription_tier.subscription_tier_id%TYPE;
BEGIN
    SELECT subscription_tier_id
      INTO v_id
      FROM p_subscription_tier
     WHERE name = 'TESTE_Premium';
    sp_delete_subscription_tier(v_id);
END;