   SET SERVEROUTPUT ON;

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
        'expense',
        1,
        1
    );
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
        'expense',
        2,
        2
    );
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
END;
/


SELECT *
  FROM p_category;