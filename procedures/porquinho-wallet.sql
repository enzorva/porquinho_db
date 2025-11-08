   SET SERVEROUTPUT ON;

-- Tabela Wallet
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_wallet (
    p_user_id     IN p_wallet.user_id%TYPE,
    p_name        IN p_wallet.name%TYPE,
    p_description IN p_wallet.description%TYPE DEFAULT NULL
) AS
BEGIN
    INSERT INTO p_wallet (
        user_id,
        name,
        description
    ) VALUES ( p_user_id,
               p_name,
               p_description );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -20001,
            'O usuário já possui uma carteira com esse nome.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -20002,
            'Erro ao inserir carteira: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE pr_update_wallet (
    p_wallet_id   IN p_wallet.wallet_id%TYPE,
    p_user_id     IN p_wallet.user_id%TYPE,
    p_name        IN p_wallet.name%TYPE,
    p_description IN p_wallet.description%TYPE
) AS
BEGIN
    UPDATE p_wallet
       SET user_id = p_user_id,
           name = p_name,
           description = p_description,
           updated_at = systimestamp
     WHERE wallet_id = p_wallet_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20003,
            'Carteira não encontrada para atualização.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -20004,
            'O usuário já possui outra carteira com esse nome.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -20005,
            'Erro ao atualizar carteira: ' || sqlerrm
        );
END;
/




-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_wallet (
    p_wallet_id IN p_wallet.wallet_id%TYPE
) AS
BEGIN
    DELETE FROM p_wallet
     WHERE wallet_id = p_wallet_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20006,
            'Carteira não encontrada para remoção.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Possível erro: FK de transações dentro da carteira
        raise_application_error(
            -20007,
            'Erro ao remover carteira: ' || sqlerrm
        );
END;
/



-- ======================================================================

-- Teste

--INSERT
BEGIN
    pr_insert_wallet(
        1,
        'TESTE_Poupança',
        'Minha reserva de emergência'
    );
END;

--UPDATE
DECLARE
    v_id p_wallet.wallet_id%TYPE;
BEGIN
    SELECT wallet_id
      INTO v_id
      FROM p_wallet
     WHERE name = 'TESTE_Poupança';
    pr_update_wallet(
        v_id,
        1,
        'TESTE_Viagem 2026',
        'Fundo para Europa'
    );
END;

--DELETE
DECLARE
    v_id p_wallet.wallet_id%TYPE;
BEGIN
    SELECT wallet_id
      INTO v_id
      FROM p_wallet
     WHERE name = 'TESTE_Viagem 2026';
    pr_delete_wallet(v_id);
END;
/