-- Tabela Bank
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_bank (
    p_name     IN p_bank.name%TYPE,
    p_code     IN p_bank.code%TYPE,
    p_logo_url IN p_bank.logo_url%TYPE
) AS
BEGIN
    INSERT INTO p_bank (
        name,
        code,
        logo_url
    ) VALUES ( p_name,
               p_code,
               p_logo_url );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -27030,
            'Já existe um banco com esse nome ou código.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -27031,
            'Erro ao inserir banco: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE pr_update_bank (
    p_bank_id  IN p_bank.bank_id%TYPE,
    p_name     IN p_bank.name%TYPE,
    p_code     IN p_bank.code%TYPE,
    p_logo_url IN p_bank.logo_url%TYPE
) AS
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO v_exists
      FROM p_bank
     WHERE bank_id = p_bank_id;

    IF v_exists = 0 THEN
        raise_application_error(
            -27032,
            'Banco não encontrado para atualização.'
        );
    END IF;
    UPDATE p_bank
       SET name = p_name,
           code = p_code,
           logo_url = p_logo_url
     WHERE bank_id = p_bank_id;

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -27033,
            'Já existe um banco com esse nome ou código.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -27034,
            'Erro ao atualizar banco: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_bank (
    p_bank_id IN p_bank.bank_id%TYPE
) AS
BEGIN
    DELETE FROM p_bank
     WHERE bank_id = p_bank_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -27035,
            'Banco não encontrado para remoção.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -27036,
            'Erro ao remover banco: ' || sqlerrm
        );
END;
/



-- ======================================================================

-- Teste

--INSERT
BEGIN
    pr_insert_bank(
        'TESTE_Nubank',
        '260',
        'https://nubank.com.br/logo.png'
    );
    dbms_output.put_line('1 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('1 ERRO');
END;
/
BEGIN
    pr_insert_bank(
        'TESTE_Nubank',
        '999',
        'Duplicado'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27030 THEN
            dbms_output.put_line('2 OK');
        ELSE
            dbms_output.put_line('2 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_bank(
        NULL,
        '001',
        'Invalido'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27031 THEN
            dbms_output.put_line('3 OK');
        ELSE
            dbms_output.put_line('3 ERRO');
        END IF;
END;
/
--UPDATE
DECLARE
    v_id p_bank.bank_id%TYPE;
BEGIN
    SELECT bank_id
      INTO v_id
      FROM p_bank
     WHERE name = 'TESTE_Nubank';
    pr_update_bank(
        v_id,
        'TESTE_Inter',
        '077',
        'https://inter.co/logo.png'
    );
    dbms_output.put_line('4 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('4 ERRO');
END;
/
BEGIN
    pr_update_bank(
        0,
        'X',
        '000',
        ''
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27032 THEN
            dbms_output.put_line('5 OK');
        ELSE
            dbms_output.put_line('5 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_bank(
        'TESTE_Bradesco',
        '237',
        'https://bradesco.com.br'
    );
    SELECT bank_id
      INTO v_id
      FROM p_bank
     WHERE name = 'TESTE_Inter';
    pr_update_bank(
        v_id,
        'TESTE_Bradesco',
        '237',
        'duplicate'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27033 THEN
            dbms_output.put_line('6 OK');
        ELSE
            dbms_output.put_line('6 ERRO');
        END IF;
END;
/
--DELETE
DECLARE
    v_id p_bank.bank_id%TYPE;
BEGIN
    SELECT bank_id
      INTO v_id
      FROM p_bank
     WHERE name = 'TESTE_Inter';
    pr_delete_bank(v_id);
    dbms_output.put_line('7 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('7 ERRO');
END;
/
BEGIN
    pr_delete_bank(0);
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27035 THEN
            dbms_output.put_line('8 OK');
        ELSE
            dbms_output.put_line('8 ERRO');
        END IF;
END;
/