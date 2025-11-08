   SET SERVEROUTPUT ON;

-- Tabela City
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_city (
    p_name     IN p_city.name%TYPE,
    p_state_id IN p_city.state_id%TYPE
) AS
BEGIN
    INSERT INTO p_city (
        name,
        state_id
    ) VALUES ( p_name,
               p_state_id );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -24001,
            'Já existe uma cidade com esse nome.'
        );
    WHEN OTHERS THEN
        -- Possível erro: FK não encontrada
        raise_application_error(
            -24002,
            'Erro ao inserir cidade: ' || sqlerrm
        );
END;
/

-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE pr_update_city (
    p_city_id  IN p_city.city_id%TYPE,
    p_name     IN p_city.name%TYPE,
    p_state_id IN p_city.state_id%TYPE
) AS
BEGIN
    UPDATE p_city
       SET name = p_name,
           state_id = p_state_id
     WHERE city_id = p_city_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -24003,
            'Nenhuma cidade encontrada com o ID informado.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -24004,
            'Já existe uma cidade com esse nome.'
        );
    WHEN OTHERS THEN
        -- Possível erro: FK não encontrada
        raise_application_error(
            -24005,
            'Erro ao atualizar cidade: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_city (
    p_city_id IN p_city.city_id%TYPE
) AS
BEGIN
    DELETE FROM p_city
     WHERE city_id = p_city_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -24006,
            'Nenhuma cidade encontrada com o ID informado.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Possível erro: existe FK de outros registros apontando para a cidade
        raise_application_error(
            -24007,
            'Erro ao remover cidade: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Teste

--INSERT
BEGIN
    pr_insert_city(
        'TESTE_Campinas',
        1
    );
END;
/
--UPDATE
DECLARE
    v_id p_city.city_id%TYPE;
BEGIN
    SELECT city_id
      INTO v_id
      FROM p_city
     WHERE name = 'TESTE_Campinas';
    pr_update_city(
        v_id,
        'TESTE_Santos',
        1
    );
END;
/
--DELETE
DECLARE
    v_id p_city.city_id%TYPE;
BEGIN
    SELECT city_id
      INTO v_id
      FROM p_city
     WHERE name = 'TESTE_Santos';
    pr_delete_city(v_id);
END;
/


SELECT *
  FROM p_city;