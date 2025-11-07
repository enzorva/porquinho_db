-- Tabela Account
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_account (
    p_wallet_id       IN p_account.wallet_id%TYPE,
    p_name            IN p_account.name%TYPE,
    p_account_type_id IN p_account.account_type_id%TYPE,
    p_bank_id         IN p_account.bank_id%TYPE,
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
        account_icon_id
    ) VALUES ( p_wallet_id,
               p_name,
               p_account_type_id,
               p_bank_id,
               p_balance,
               p_overdraft,
               p_color_id,
               p_account_icon_id );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -27040,
            'Já existe uma conta com esse nome nesta carteira.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -27041,
            'Erro ao inserir conta: ' || sqlerrm
        );
END;
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
            -27042,
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
            -27043,
            'Já existe uma conta com esse nome nesta carteira.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -27044,
            'Erro ao atualizar conta: ' || sqlerrm
        );
END;
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
            -27045,
            'Conta não encontrada para remoção.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Possível FK: transações dependentes
        raise_application_error(
            -27046,
            'Erro ao remover conta: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Teste

--INSERT
BEGIN
    pr_insert_account(
        1,
        'TESTE_NuConta',
        1,
        1,
        5000,
        1000,
        1,
        1
    );
    dbms_output.put_line('1 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('1 ERRO');
END;
/
BEGIN
    pr_insert_account(
        1,
        'TESTE_NuConta',
        1,
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27040 THEN
            dbms_output.put_line('2 OK');
        ELSE
            dbms_output.put_line('2 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_account(
        99999,
        'TESTE_FK',
        1,
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27041 THEN
            dbms_output.put_line('3 OK');
        ELSE
            dbms_output.put_line('3 ERRO');
        END IF;
END;
/
--UPDATE
DECLARE
    v_id p_account.account_id%TYPE;
BEGIN
    SELECT account_id
      INTO v_id
      FROM p_account
     WHERE name = 'TESTE_NuConta';
    pr_update_account(
        v_id,
        'TESTE_Inter',
        2,
        2,
        8000,
        2000,
        2,
        2
    );
    dbms_output.put_line('4 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('4 ERRO');
END;
/
BEGIN
    pr_update_account(
        0,
        'X',
        1,
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27042 THEN
            dbms_output.put_line('5 OK');
        ELSE
            dbms_output.put_line('5 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_account(
        1,
        'TESTE_Reserva',
        1,
        1
    );
    SELECT account_id
      INTO v_id
      FROM p_account
     WHERE name = 'TESTE_Inter';
    pr_update_account(
        v_id,
        'TESTE_Reserva',
        1,
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27043 THEN
            dbms_output.put_line('6 OK');
        ELSE
            dbms_output.put_line('6 ERRO');
        END IF;
END;
/
--DELETE
DECLARE
    v_id p_account.account_id%TYPE;
BEGIN
    SELECT account_id
      INTO v_id
      FROM p_account
     WHERE name = 'TESTE_Inter';
    pr_delete_account(v_id);
    dbms_output.put_line('7 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('7 ERRO');
END;
/
BEGIN
    pr_delete_account(0);
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27045 THEN
            dbms_output.put_line('8 OK');
        ELSE
            dbms_output.put_line('8 ERRO');
        END IF;
END;
/