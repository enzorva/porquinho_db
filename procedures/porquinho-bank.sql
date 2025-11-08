   SET SERVEROUTPUT ON;

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
            -20030,
            'Já existe um banco com esse nome ou código.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -20031,
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
            -20032,
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
            -20033,
            'Já existe um banco com esse nome ou código.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -20034,
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
            -20035,
            'Banco não encontrado para remoção.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20036,
            'Erro ao remover banco: ' || sqlerrm
        );
END;
/



-- ======================================================================

-- Teste

--INSERT
BEGIN
    pr_insert_bank(
        'TESTE_Banco_Master',
        '230',
        'https://nubank.com.br/logo.png'
    );
END;
/
--UPDATE
DECLARE
    v_id p_bank.bank_id%TYPE;
BEGIN
    SELECT bank_id
      INTO v_id
      FROM p_bank
     WHERE name = 'TESTE_Banco_Master';
    pr_update_bank(
        v_id,
        'TESTE_Banco_pan',
        '087',
        'https://inter.co/logo.png'
    );
END;
/
--DELETE
DECLARE
    v_id p_bank.bank_id%TYPE;
BEGIN
    SELECT bank_id
      INTO v_id
      FROM p_bank
     WHERE name = 'TESTE_Banco_pan';
    pr_delete_bank(v_id);
END;
/

SELECT *
  FROM p_bank;