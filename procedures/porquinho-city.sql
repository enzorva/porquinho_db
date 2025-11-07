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
    dbms_output.put_line('1 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('1 ERRO');
END;
/
BEGIN
    pr_insert_city(
        'TESTE_Campinas',
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -24001 THEN
            dbms_output.put_line('2 OK');
        ELSE
            dbms_output.put_line('2 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_city(
        'TESTE_Inexistente',
        99999
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -24002 THEN
            dbms_output.put_line('3 OK');
        ELSE
            dbms_output.put_line('3 ERRO');
        END IF;
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
    dbms_output.put_line('4 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('4 ERRO');
END;
/
BEGIN
    pr_update_city(
        0,
        'X',
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -24003 THEN
            dbms_output.put_line('5 OK');
        ELSE
            dbms_output.put_line('5 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_city(
        'TESTE_Santos',
        1
    );
    SELECT city_id
      INTO v_id
      FROM p_city
     WHERE name = 'TESTE_Santos'
       AND ROWNUM = 1;
    pr_update_city(
        v_id,
        'TESTE_Campinas',
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -24004 THEN
            dbms_output.put_line('6 OK');
        ELSE
            dbms_output.put_line('6 ERRO');
        END IF;
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
    dbms_output.put_line('7 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('7 ERRO');
END;
/
BEGIN
    pr_delete_city(0);
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -24006 THEN
            dbms_output.put_line('8 OK');
        ELSE
            dbms_output.put_line('8 ERRO');
        END IF;
END;
/