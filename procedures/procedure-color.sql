   SET SERVEROUTPUT ON;


CREATE OR REPLACE PROCEDURE pr_insert_color (
    p_name IN p_color.name%TYPE,
    p_hex  IN p_color.hex%TYPE
) AS
BEGIN
    INSERT INTO p_color (
        name,
        hex
    ) VALUES ( p_name,
               p_hex );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -20001,
            'Já existe um registro com esse nome ou hex.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -20002,
            'Erro ao inserir cor: ' || sqlerrm
        );
END;



-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE pr_update_color (
    p_color_id IN p_color.color_id%TYPE,
    p_name     IN p_color.name%TYPE,
    p_hex      IN p_color.hex%TYPE
) AS
BEGIN
    UPDATE p_color
       SET name = p_name,
           hex = p_hex
     WHERE color_id = p_color_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20003,
            'Nenhuma cor encontrada com o ID informado.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -20004,
            'Já existe um registro com esse nome ou hex.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -20005,
            'Erro ao atualizar cor: ' || sqlerrm
        );
END;


-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_color (
    p_color_id IN p_color.color_id%TYPE
) AS
BEGIN
    DELETE FROM p_color
     WHERE color_id = p_color_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20006,
            'Nenhuma cor encontrada com o ID informado.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20007,
            'Erro ao remover cor: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Teste

-- INSERT
BEGIN
    pr_insert_color(
        'TESTE_Rosa',
        '#ff00f2'
    );
END;

-- UPDATE
DECLARE
    v_id p_color.color_id%TYPE;
BEGIN
    SELECT color_id
      INTO v_id
      FROM p_color
     WHERE name = 'TESTE_Rosa';
    pr_update_color(
        v_id,
        'TESTE_Rosa',
        '#00F000'
    );
END;
/
-- DELETE
DECLARE
    v_id p_color.color_id%TYPE;
BEGIN
    SELECT color_id
      INTO v_id
      FROM p_color
     WHERE name = 'TESTE_Rosa';
    pr_delete_color(v_id);
END;
/

SELECT *
  FROM p_color;