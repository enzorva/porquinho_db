   SET SERVEROUTPUT ON;

-- Tabela Transaction Category
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_transaction_category (
    p_transaction_id IN p_transaction_category.transaction_id%TYPE,
    p_category_id    IN p_transaction_category.category_id%TYPE
) AS
BEGIN
    INSERT INTO p_transaction_category (
        transaction_id,
        category_id
    ) VALUES ( p_transaction_id,
               p_category_id );

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20401,
            'Erro ao vincular categoria à transação: ' || sqlerrm
        );
END;


-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE pr_update_transaction_category (
    p_old_transaction_id IN p_transaction_category.transaction_id%TYPE,
    p_old_category_id    IN p_transaction_category.category_id%TYPE,
    p_new_transaction_id IN p_transaction_category.transaction_id%TYPE,
    p_new_category_id    IN p_transaction_category.category_id%TYPE
) AS
BEGIN
    UPDATE p_transaction_category
       SET transaction_id = p_new_transaction_id,
           category_id = p_new_category_id
     WHERE transaction_id = p_old_transaction_id
       AND category_id = p_old_category_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20402,
            'Vínculo não encontrado para atualização.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20403,
            'Erro ao atualizar vínculo de categoria da transação: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_transaction_category (
    p_transaction_id IN p_transaction_category.transaction_id%TYPE,
    p_category_id    IN p_transaction_category.category_id%TYPE
) AS
BEGIN
    DELETE FROM p_transaction_category
     WHERE transaction_id = p_transaction_id
       AND category_id = p_category_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20404,
            'Vínculo não encontrado para exclusão.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20405,
            'Erro ao excluir vínculo de categoria da transação: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Teste

--INSERT
BEGIN
    pr_insert_transaction_category(
        1,
        1
    );
END;
/
--UPDATE
BEGIN
    pr_update_transaction_category(
        1,
        1,
        1,
        2
    );
    dbms_output.put_line('3 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('3 ERRO');
END;
/
--DELETE
BEGIN
    pr_delete_transaction_category(
        1,
        2
    );
END;
/