-- Tabela Transaction Icon
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_transaction_icon (
    p_label IN p_transaction_icon.label%TYPE,
    p_url   IN p_transaction_icon.url%TYPE
) AS
BEGIN
    INSERT INTO p_transaction_icon (
        label,
        url
    ) VALUES ( p_label,
               p_url );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -20001,
            'Label ou URL já cadastrado.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -20002,
            'Erro ao inserir ícone: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE pr_update_transaction_icon (
    p_transaction_icon_id IN p_transaction_icon.transaction_icon_id%TYPE,
    p_label               IN p_transaction_icon.label%TYPE,
    p_url                 IN p_transaction_icon.url%TYPE
) AS
BEGIN
    UPDATE p_transaction_icon
       SET label = p_label,
           url = p_url
     WHERE transaction_icon_id = p_transaction_icon_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20003,
            'Ícone não encontrado para atualização.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -20004,
            'Label ou URL já cadastrado.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -20005,
            'Erro ao atualizar ícone: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_transaction_icon (
    p_transaction_icon_id IN p_transaction_icon.transaction_icon_id%TYPE
) AS
BEGIN
    DELETE FROM p_transaction_icon
     WHERE transaction_icon_id = p_transaction_icon_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20006,
            'Ícone não encontrado para exclusão.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20007,
            'Erro ao excluir ícone: ' || sqlerrm
        );
END;
/



-- ======================================================================

-- Teste

--INSERT
BEGIN
    pr_insert_transaction_icon(
        'TESTE_Supermercado',
        '/icons/supermarket.svg'
    );
    dbms_output.put_line('1 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('1 ERRO');
END;
/
BEGIN
    pr_insert_transaction_icon(
        'TESTE_Supermercado',
        '/icons/other.svg'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -20001 THEN
            dbms_output.put_line('2 OK');
        ELSE
            dbms_output.put_line('2 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_transaction_icon(
        NULL,
        '/icons/null.svg'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -20002 THEN
            dbms_output.put_line('3 OK');
        ELSE
            dbms_output.put_line('3 ERRO');
        END IF;
END;
/
--UPDATE
DECLARE
    v_id p_transaction_icon.transaction_icon_id%TYPE;
BEGIN
    SELECT transaction_icon_id
      INTO v_id
      FROM p_transaction_icon
     WHERE label = 'TESTE_Supermercado';
    pr_update_transaction_icon(
        v_id,
        'TESTE_Restaurante',
        '/icons/restaurant.svg'
    );
    dbms_output.put_line('4 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('4 ERRO');
END;
/
BEGIN
    pr_update_transaction_icon(
        0,
        'X',
        'Y'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -20003 THEN
            dbms_output.put_line('5 OK');
        ELSE
            dbms_output.put_line('5 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_transaction_icon(
        'TESTE_Transporte',
        '/icons/bus.svg'
    );
    SELECT transaction_icon_id
      INTO v_id
      FROM p_transaction_icon
     WHERE label = 'TESTE_Restaurante';
    pr_update_transaction_icon(
        v_id,
        'TESTE_Transporte',
        '/icons/train.svg'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -20004 THEN
            dbms_output.put_line('6 OK');
        ELSE
            dbms_output.put_line('6 ERRO');
        END IF;
END;
/
--DELETE
DECLARE
    v_id p_transaction_icon.transaction_icon_id%TYPE;
BEGIN
    SELECT transaction_icon_id
      INTO v_id
      FROM p_transaction_icon
     WHERE label = 'TESTE_Restaurante';
    pr_delete_transaction_icon(v_id);
    dbms_output.put_line('7 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('7 ERRO');
END;
/
BEGIN
    pr_delete_transaction_icon(0);
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -20006 THEN
            dbms_output.put_line('8 OK');
        ELSE
            dbms_output.put_line('8 ERRO');
        END IF;
END;
/