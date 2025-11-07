-- Tabela Category
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_category (
    p_user_id          IN p_category.user_id%TYPE,
    p_name             IN p_category.name%TYPE,
    p_type             IN p_category.type%TYPE,
    p_category_icon_id IN p_category.category_icon_id%TYPE,
    p_color_id         IN p_category.color_id%TYPE
) AS
BEGIN
    INSERT INTO p_category (
        user_id,
        name,
        type,
        category_icon_id,
        color_id
    ) VALUES ( p_user_id,
               p_name,
               p_type,
               p_category_icon_id,
               p_color_id );

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20301,
            'Erro ao inserir categoria: ' || sqlerrm
        );
END;


-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE pr_update_category (
    p_category_id      IN p_category.category_id%TYPE,
    p_user_id          IN p_category.user_id%TYPE,
    p_name             IN p_category.name%TYPE,
    p_type             IN p_category.type%TYPE,
    p_category_icon_id IN p_category.category_icon_id%TYPE,
    p_color_id         IN p_category.color_id%TYPE
) AS
BEGIN
    UPDATE p_category
       SET user_id = p_user_id,
           name = p_name,
           type = p_type,
           category_icon_id = p_category_icon_id,
           color_id = p_color_id,
           updated_at = systimestamp
     WHERE category_id = p_category_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20302,
            'Categoria não encontrada para atualização.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20303,
            'Erro ao atualizar categoria: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_category (
    p_category_id IN p_category.category_id%TYPE
) AS
BEGIN
    DELETE FROM p_category
     WHERE category_id = p_category_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20304,
            'Categoria não encontrada para exclusão.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Possível erro: FK com transações que usam esta categoria
        raise_application_error(
            -20305,
            'Erro ao excluir categoria: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Teste

--INSERT
BEGIN
    pr_insert_category(
        1,
        'TESTE_Alimentacao',
        'EXPENSE',
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
    pr_insert_category(
        99999,
        'TESTE_FK',
        'INCOME',
        999,
        999
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -20301 THEN
            dbms_output.put_line('2 OK');
        ELSE
            dbms_output.put_line('2 ERRO');
        END IF;
END;
/
--UPDATE
DECLARE
    v_id p_category.category_id%TYPE;
BEGIN
    SELECT category_id
      INTO v_id
      FROM p_category
     WHERE name = 'TESTE_Alimentacao';
    pr_update_category(
        v_id,
        1,
        'TESTE_Transporte',
        'EXPENSE',
        2,
        2
    );
    dbms_output.put_line('3 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('3 ERRO');
END;
/
BEGIN
    pr_update_category(
        0,
        1,
        'X',
        'X',
        1,
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -20302 THEN
            dbms_output.put_line('4 OK');
        ELSE
            dbms_output.put_line('4 ERRO');
        END IF;
END;
/
--DELETE
DECLARE
    v_id p_category.category_id%TYPE;
BEGIN
    SELECT category_id
      INTO v_id
      FROM p_category
     WHERE name = 'TESTE_Transporte';
    pr_delete_category(v_id);
    dbms_output.put_line('5 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('5 ERRO');
END;
/
BEGIN
    pr_delete_category(0);
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -20304 THEN
            dbms_output.put_line('6 OK');
        ELSE
            dbms_output.put_line('6 ERRO');
        END IF;
END;
/