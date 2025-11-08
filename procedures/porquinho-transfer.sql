   SET SERVEROUTPUT ON;

-- Tabela Transfer
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_transfer (
    p_value                  IN p_transfer.value%TYPE,
    p_origin_account_id      IN p_transfer.origin_account_id%TYPE,
    p_destination_account_id IN p_transfer.destination_account_id%TYPE,
    p_description            IN p_transfer.description%TYPE
) AS
    v_origin_balance NUMBER;
BEGIN
    IF p_origin_account_id = p_destination_account_id THEN
        raise_application_error(
            -27050,
            'A conta de origem não pode ser igual à conta de destino.'
        );
    END IF;
    SELECT balance
      INTO v_origin_balance
      FROM p_account
     WHERE account_id = p_origin_account_id
    FOR UPDATE;

    SELECT COUNT(*)
      INTO v_origin_balance
      FROM p_account
     WHERE account_id = p_destination_account_id;

    IF v_origin_balance = 0 THEN
        raise_application_error(
            -27051,
            'Conta de destino inexistente.'
        );
    END IF;
    IF v_origin_balance < p_value THEN
        raise_application_error(
            -27052,
            'Saldo insuficiente para transferência.'
        );
    END IF;
    UPDATE p_account
       SET balance = balance - p_value,
           updated_at = systimestamp
     WHERE account_id = p_origin_account_id;

    UPDATE p_account
       SET balance = balance + p_value,
           updated_at = systimestamp
     WHERE account_id = p_destination_account_id;

    INSERT INTO p_transfer (
        value,
        origin_account_id,
        destination_account_id,
        description
    ) VALUES ( p_value,
               p_origin_account_id,
               p_destination_account_id,
               p_description );

    COMMIT;
EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(
            -27053,
            'Conta de origem não encontrada.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -27054,
            'Erro ao registrar transferência: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE pr_update_transfer (
    p_transfer_id IN p_transfer.transfer_id%TYPE,
    p_description IN p_transfer.description%TYPE
) AS
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO v_exists
      FROM p_transfer
     WHERE transfer_id = p_transfer_id;

    IF v_exists = 0 THEN
        raise_application_error(
            -27055,
            'Transferência não encontrada para atualização.'
        );
    END IF;
    UPDATE p_transfer
       SET description = p_description,
           updated_at = systimestamp
     WHERE transfer_id = p_transfer_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -27056,
            'Erro ao atualizar transferência: ' || sqlerrm
        );
END;


-- ======================================================================

-- Cancel

CREATE OR REPLACE PROCEDURE pr_cancel_transfer (
    p_transfer_id IN p_transfer.transfer_id%TYPE
) AS
    v_value       NUMBER;
    v_origin      NUMBER;
    v_destination NUMBER;
BEGIN
    SELECT value,
           origin_account_id,
           destination_account_id
      INTO
        v_value,
        v_origin,
        v_destination
      FROM p_transfer
     WHERE transfer_id = p_transfer_id
    FOR UPDATE;

    -- Estorna saldo
    UPDATE p_account
       SET balance = balance + v_value,
           updated_at = systimestamp
     WHERE account_id = v_origin;

    UPDATE p_account
       SET balance = balance - v_value,
           updated_at = systimestamp
     WHERE account_id = v_destination;

    DELETE FROM p_transfer
     WHERE transfer_id = p_transfer_id;

    COMMIT;
EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(
            -27057,
            'Transferência não encontrada para cancelamento.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -27058,
            'Erro ao cancelar transferência: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Teste

--INSERT
BEGIN
    pr_insert_transfer(
        500,
        1,
        2,
        'TESTE_Transferência OK'
    );
    dbms_output.put_line('1 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('1 ERRO');
END;
/
BEGIN
    pr_insert_transfer(
        500,
        1,
        1,
        'TESTE_Mesma conta'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27050 THEN
            dbms_output.put_line('2 OK');
        ELSE
            dbms_output.put_line('2 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_transfer(
        15000,
        1,
        2,
        'TESTE_Saldo insuficiente'
    );
END;
/
--UPDATE
DECLARE
    v_id p_transfer.transfer_id%TYPE;
BEGIN
    SELECT transfer_id
      INTO v_id
      FROM p_transfer
     WHERE description = 'TESTE_Transferência OK';
    pr_update_transfer(
        v_id,
        'TESTE_Descrição atualizada'
    );
END;
/
--CANCEL
DECLARE
    v_id p_transfer.transfer_id%TYPE;
BEGIN
    SELECT transfer_id
      INTO v_id
      FROM p_transfer
     WHERE description = 'TESTE_Descrição atualizada';
    pr_cancel_transfer(v_id);
    dbms_output.put_line('7 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('7 ERRO');
END;
/