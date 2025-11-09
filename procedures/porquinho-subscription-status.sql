   SET SERVEROUTPUT ON;

-- Tabela Subscription Status
-- Insert

CREATE OR REPLACE PROCEDURE sp_insert_subscription_status (
    p_description IN p_subscription_status.description%TYPE,
    p_code        IN p_subscription_status.code%TYPE
) AS
BEGIN
    INSERT INTO p_subscription_status (
        description,
        code
    ) VALUES ( p_description,
               p_code );

    dbms_output.put_line('Status de assinatura inserido com sucesso.');
EXCEPTION
    WHEN dup_val_on_index THEN
        dbms_output.put_line('Erro: Já existe um status com essa descrição ou código.');
    WHEN OTHERS THEN
        dbms_output.put_line('Erro inesperado: ' || sqlerrm);
END;


-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE sp_update_subscription_status (
    p_subscription_status_id IN p_subscription_status.subscription_status_id%TYPE,
    p_description            IN p_subscription_status.description%TYPE,
    p_code                   IN p_subscription_status.code%TYPE
) AS
BEGIN
    UPDATE p_subscription_status
       SET description = p_description,
           code = p_code
     WHERE subscription_status_id = p_subscription_status_id;

    IF SQL%rowcount = 0 THEN
        dbms_output.put_line('Nenhum registro encontrado para atualização.');
    ELSE
        dbms_output.put_line('Status de assinatura atualizado com sucesso.');
    END IF;

EXCEPTION
    WHEN dup_val_on_index THEN
        dbms_output.put_line('Erro: Já existe um status com essa descrição ou código.');
    WHEN OTHERS THEN
        dbms_output.put_line('Erro inesperado: ' || sqlerrm);
END;


-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE sp_delete_subscription_status (
    p_subscription_status_id IN p_subscription_status.subscription_status_id%TYPE
) AS
BEGIN
    DELETE FROM p_subscription_status
     WHERE subscription_status_id = p_subscription_status_id;

    IF SQL%rowcount = 0 THEN
        dbms_output.put_line('Nenhum registro encontrado para remoção.');
    ELSE
        dbms_output.put_line('Status de assinatura removido com sucesso.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Erro inesperado: ' || sqlerrm);
END;


-- ======================================================================

-- Teste

--INSERT
BEGIN
    sp_insert_subscription_status(
        'TESTE_Ativo',
        'TESTE_ACTIVE'
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
--UPDATE
DECLARE
    v_id p_subscription_status.subscription_status_id%TYPE;
BEGIN
    SELECT subscription_status_id
      INTO v_id
      FROM p_subscription_status
     WHERE description = 'TESTE_Ativo';
    sp_update_subscription_status(
        v_id,
        'TESTE_Cancelado',
        'CANCELED'
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
--DELETE
DECLARE
    v_id p_subscription_status.subscription_status_id%TYPE;
BEGIN
    SELECT subscription_status_id
      INTO v_id
      FROM p_subscription_status
     WHERE description = 'TESTE_Cancelado';
    sp_delete_subscription_status(v_id);
END;
/

SELECT *
  FROM p_subscription_status;