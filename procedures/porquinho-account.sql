   SET SERVEROUTPUT ON;
-- Tabela p_account

-- Insert
CREATE OR REPLACE PROCEDURE pr_insert_account (
    p_wallet_id       IN p_account.wallet_id%TYPE,
    p_name            IN p_account.name%TYPE,
    p_account_type_id IN p_account.account_type_id%TYPE,
    p_bank_id         IN p_account.bank_id%TYPE DEFAULT NULL,
    p_balance         IN p_account.balance%TYPE DEFAULT 0,
    p_overdraft       IN p_account.overdraft%TYPE DEFAULT 0,
    p_color_id        IN p_account.color_id%TYPE,
    p_account_icon_id IN p_account.account_icon_id%TYPE
) AS
BEGIN
    INSERT INTO p_account (
        wallet_id,
        name,
        account_type_id,
        bank_id,
        balance,
        overdraft,
        color_id,
        account_icon_id,
        created_at
    ) VALUES ( p_wallet_id,
               p_name,
               p_account_type_id,
               p_bank_id,
               p_balance,
               p_overdraft,
               p_color_id,
               p_account_icon_id,
               systimestamp );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -20040,
            'Já existe uma conta com esse nome nesta carteira.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -20041,
            'Erro ao inserir conta: ' || sqlerrm
        );
END pr_insert_account;
/

-- ======================================================================
-- Update
CREATE OR REPLACE PROCEDURE pr_update_account (
    p_account_id      IN p_account.account_id%TYPE,
    p_name            IN p_account.name%TYPE,
    p_account_type_id IN p_account.account_type_id%TYPE,
    p_bank_id         IN p_account.bank_id%TYPE,
    p_balance         IN p_account.balance%TYPE,
    p_overdraft       IN p_account.overdraft%TYPE,
    p_color_id        IN p_account.color_id%TYPE,
    p_account_icon_id IN p_account.account_icon_id%TYPE
) AS
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO v_exists
      FROM p_account
     WHERE account_id = p_account_id;

    IF v_exists = 0 THEN
        raise_application_error(
            -20042,
            'Conta não encontrada para atualização.'
        );
    END IF;
    UPDATE p_account
       SET name = p_name,
           account_type_id = p_account_type_id,
           bank_id = p_bank_id,
           balance = p_balance,
           overdraft = p_overdraft,
           color_id = p_color_id,
           account_icon_id = p_account_icon_id,
           updated_at = systimestamp
     WHERE account_id = p_account_id;

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -20043,
            'Já existe uma conta com esse nome nesta carteira.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -20044,
            'Erro ao atualizar conta: ' || sqlerrm
        );
END pr_update_account;
/


-- ======================================================================
-- Delete
CREATE OR REPLACE PROCEDURE pr_delete_account (
    p_account_id IN p_account.account_id%TYPE
) AS
BEGIN
    DELETE FROM p_account
     WHERE account_id = p_account_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20045,
            'Conta não encontrada para remoção.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Possível FK: transações dependentes
        raise_application_error(
            -20046,
            'Erro ao remover conta: ' || sqlerrm
        );
END pr_delete_account;
/



-- Testes
-- INSERT
BEGIN
    pr_insert_account(
        p_wallet_id       => 1,
        p_name            => 'Conta Teste PicPay',
        p_account_type_id => 8,
        p_bank_id         => 10,
        p_balance         => 1500.50,
        p_overdraft       => 0,
        p_color_id        => 5,
        p_account_icon_id => 4
    );
    dbms_output.put_line('Conta inserida com sucesso!');
END;
/

SELECT *
  FROM p_account
 WHERE name = 'Conta Teste PicPay';
/


-- UPDATE
DECLARE
    v_account_id p_account.account_id%TYPE;
BEGIN
    SELECT account_id
      INTO v_account_id
      FROM p_account
     WHERE name = 'Conta Teste PicPay';

    pr_update_account(
        p_account_id      => v_account_id,
        p_name            => 'Conta Teste PicPay Atualizada',
        p_account_type_id => 8,
        p_bank_id         => 10,
        p_balance         => 2500.75,
        p_overdraft       => 1,
        p_color_id        => 6,
        p_account_icon_id => 5
    );
    dbms_output.put_line('Conta atualizada com sucesso!');
END;
/

-- DELETE
DECLARE
    v_account_id p_account.account_id%TYPE;
BEGIN
    SELECT account_id
      INTO v_account_id
      FROM p_account
     WHERE name = 'Conta Teste PicPay Atualizada';

    pr_delete_account(p_account_id => v_account_id);
    dbms_output.put_line('Conta removida com sucesso!');
END;
/


SELECT *
  FROM p_account;