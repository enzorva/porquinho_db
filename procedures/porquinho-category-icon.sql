   SET SERVEROUTPUT ON;

-- Tabela Category Icon
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_category_icon (
    p_label IN p_category_icon.label%TYPE,
    p_url   IN p_category_icon.url%TYPE
) AS
BEGIN
    INSERT INTO p_category_icon (
        label,
        url
    ) VALUES ( p_label,
               p_url );

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20201,
            'Erro ao inserir ícone de categoria: ' || sqlerrm
        );
END;
/




-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE pr_update_category_icon (
    p_category_icon_id IN p_category_icon.category_icon_id%TYPE,
    p_label            IN p_category_icon.label%TYPE,
    p_url              IN p_category_icon.url%TYPE
) AS
BEGIN
    UPDATE p_category_icon
       SET label = p_label,
           url = p_url
     WHERE category_icon_id = p_category_icon_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20202,
            'Ícone de categoria não encontrado para atualização.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20203,
            'Erro ao atualizar ícone de categoria: ' || sqlerrm
        );
END;
/




-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_category_icon (
    p_category_icon_id IN p_category_icon.category_icon_id%TYPE
) AS
BEGIN
    DELETE FROM p_category_icon
     WHERE category_icon_id = p_category_icon_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20204,
            'Ícone de categoria não encontrado para exclusão.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20205,
            'Erro ao excluir ícone de categoria: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Teste

--INSERT
BEGIN
    pr_insert_category_icon(
        'TESTE_Alimentação',
        '/cat/food.svg'
    );
END;
/
--UPDATE
DECLARE
    v_id p_category_icon.category_icon_id%TYPE;
BEGIN
    SELECT category_icon_id
      INTO v_id
      FROM p_category_icon
     WHERE label = 'TESTE_Alimentação';
    pr_update_category_icon(
        v_id,
        'TESTE_Transporte',
        '/cat/car.svg'
    );
END;
/
--DELETE
DECLARE
    v_id p_category_icon.category_icon_id%TYPE;
BEGIN
    SELECT category_icon_id
      INTO v_id
      FROM p_category_icon
     WHERE label = 'TESTE_Transporte';
    pr_delete_category_icon(v_id);
END;
/

SELECT *
  FROM p_category_icon;