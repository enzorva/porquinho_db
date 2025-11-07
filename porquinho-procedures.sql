-- Tabela Color
-- Insert

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
        'TESTE_Azul',
        '#0000FF'
    );
    dbms_output.put_line('1 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('1 ERRO');
END;
/
BEGIN
    pr_insert_color(
        'TESTE_Azul',
        '#0000FF'
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
    pr_insert_color(
        NULL,
        '#FFFFFF'
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
-- UPDATE
DECLARE
    v_id p_color.color_id%TYPE;
BEGIN
    SELECT color_id
      INTO v_id
      FROM p_color
     WHERE name = 'TESTE_Azul';
    pr_update_color(
        v_id,
        'TESTE_Verde',
        '#00FF00'
    );
    dbms_output.put_line('4 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('4 ERRO');
END;
/
BEGIN
    pr_update_color(
        999999,
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
    SELECT color_id
      INTO v_id
      FROM p_color
     WHERE name = 'TESTE_Verde';
    pr_update_color(
        v_id,
        'TESTE_Azul',
        '#0000FF'
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
-- DELETE
DECLARE
    v_id p_color.color_id%TYPE;
BEGIN
    SELECT color_id
      INTO v_id
      FROM p_color
     WHERE name = 'TESTE_Verde';
    pr_delete_color(v_id);
    dbms_output.put_line('7 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('7 ERRO');
END;
/
BEGIN
    pr_delete_color(999999);
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -20006 THEN
            dbms_output.put_line('8 OK');
        ELSE
            dbms_output.put_line('8 ERRO');
        END IF;
END;
/

-- Tabela Finance Objective
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_finance_objective (
    p_name IN p_finance_objective.name%TYPE
) AS
BEGIN
    INSERT INTO p_finance_objective ( name ) VALUES ( p_name );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -21001,
            'Já existe um objetivo financeiro com esse nome.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -21002,
            'Erro ao inserir objetivo financeiro: ' || sqlerrm
        );
END;



-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE pr_update_finance_objective (
    p_finance_objective_id IN p_finance_objective.finance_objective_id%TYPE,
    p_name                 IN p_finance_objective.name%TYPE
) AS
BEGIN
    UPDATE p_finance_objective
       SET
        name = p_name
     WHERE finance_objective_id = p_finance_objective_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -21003,
            'Nenhum objetivo financeiro encontrado com o ID informado.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -21004,
            'Já existe um objetivo financeiro com esse nome.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -21005,
            'Erro ao atualizar objetivo financeiro: ' || sqlerrm
        );
END;
/



-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_finance_objective (
    p_finance_objective_id IN p_finance_objective.finance_objective_id%TYPE
) AS
BEGIN
    DELETE FROM p_finance_objective
     WHERE finance_objective_id = p_finance_objective_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -21006,
            'Nenhum objetivo financeiro encontrado com o ID informado.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -21007,
            'Erro ao remover objetivo financeiro: ' || sqlerrm
        );
END;
/

-- ======================================================================


-- Teste

-- INSERT
BEGIN
    pr_insert_finance_objective('TESTE_Viagem');
    dbms_output.put_line('1 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('1 ERRO');
END;
/
BEGIN
    pr_insert_finance_objective('TESTE_Viagem');
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -21001 THEN
            dbms_output.put_line('2 OK');
        ELSE
            dbms_output.put_line('2 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_finance_objective(NULL);
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -21002 THEN
            dbms_output.put_line('3 OK');
        ELSE
            dbms_output.put_line('3 ERRO');
        END IF;
END;
/
-- UPDATE
DECLARE
    v_id p_finance_objective.finance_objective_id%TYPE;
BEGIN
    SELECT finance_objective_id
      INTO v_id
      FROM p_finance_objective
     WHERE name = 'TESTE_Viagem';
    pr_update_finance_objective(
        v_id,
        'TESTE_Carro'
    );
    dbms_output.put_line('4 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('4 ERRO');
END;
/
BEGIN
    pr_update_finance_objective(
        999999,
        'X'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -21003 THEN
            dbms_output.put_line('5 OK');
        ELSE
            dbms_output.put_line('5 ERRO');
        END IF;
END;
/
BEGIN
    SELECT finance_objective_id
      INTO v_id
      FROM p_finance_objective
     WHERE name = 'TESTE_Carro';
    pr_update_finance_objective(
        v_id,
        'TESTE_Viagem'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -21004 THEN
            dbms_output.put_line('6 OK');
        ELSE
            dbms_output.put_line('6 ERRO');
        END IF;
END;
/
-- DELETE
DECLARE
    v_id p_finance_objective.finance_objective_id%TYPE;
BEGIN
    SELECT finance_objective_id
      INTO v_id
      FROM p_finance_objective
     WHERE name = 'TESTE_Carro';
    pr_delete_finance_objective(v_id);
    dbms_output.put_line('7 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('7 ERRO');
END;
/
BEGIN
    pr_delete_finance_objective(999999);
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -21006 THEN
            dbms_output.put_line('8 OK');
        ELSE
            dbms_output.put_line('8 ERRO');
        END IF;
END;
/

-- Tabela Time Zone
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_finance_objective (
    p_name IN p_finance_objective.name%TYPE
) AS
BEGIN
    INSERT INTO p_finance_objective ( name ) VALUES ( p_name );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -21001,
            'Já existe um objetivo financeiro com esse nome.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -21002,
            'Erro ao inserir objetivo financeiro: ' || sqlerrm
        );
END;
/





-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE pr_update_finance_objective (
    p_finance_objective_id IN p_finance_objective.finance_objective_id%TYPE,
    p_name                 IN p_finance_objective.name%TYPE
) AS
BEGIN
    UPDATE p_finance_objective
       SET
        name = p_name
     WHERE finance_objective_id = p_finance_objective_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -21003,
            'Nenhum objetivo financeiro encontrado com o ID informado.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -21004,
            'Já existe um objetivo financeiro com esse nome.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -21005,
            'Erro ao atualizar objetivo financeiro: ' || sqlerrm
        );
END;
/





-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_finance_objective (
    p_finance_objective_id IN p_finance_objective.finance_objective_id%TYPE
) AS
BEGIN
    DELETE FROM p_finance_objective
     WHERE finance_objective_id = p_finance_objective_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -21006,
            'Nenhum objetivo financeiro encontrado com o ID informado.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -21007,
            'Erro ao remover objetivo financeiro: ' || sqlerrm
        );
END;
/




-- ======================================================================

-- Teste

-- INSERT
BEGIN
    pr_insert_finance_objective('TESTE_Casa');
    dbms_output.put_line('1 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('1 ERRO');
END;
/
BEGIN
    pr_insert_finance_objective('TESTE_Casa');
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -21001 THEN
            dbms_output.put_line('2 OK');
        ELSE
            dbms_output.put_line('2 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_finance_objective(NULL);
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -21002 THEN
            dbms_output.put_line('3 OK');
        ELSE
            dbms_output.put_line('3 ERRO');
        END IF;
END;
/
-- UPDATE
DECLARE
    v_id p_finance_objective.finance_objective_id%TYPE;
BEGIN
    SELECT finance_objective_id
      INTO v_id
      FROM p_finance_objective
     WHERE name = 'TESTE_Casa';
    pr_update_finance_objective(
        v_id,
        'TESTE_Aposentadoria'
    );
    dbms_output.put_line('4 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('4 ERRO');
END;
/
BEGIN
    pr_update_finance_objective(
        0,
        'X'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -21003 THEN
            dbms_output.put_line('5 OK');
        ELSE
            dbms_output.put_line('5 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_finance_objective('TESTE_Viagem');
    SELECT finance_objective_id
      INTO v_id
      FROM p_finance_objective
     WHERE name = 'TESTE_Aposentadoria';
    pr_update_finance_objective(
        v_id,
        'TESTE_Viagem'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -21004 THEN
            dbms_output.put_line('6 OK');
        ELSE
            dbms_output.put_line('6 ERRO');
        END IF;
END;
/
-- DELETE
DECLARE
    v_id p_finance_objective.finance_objective_id%TYPE;
BEGIN
    SELECT finance_objective_id
      INTO v_id
      FROM p_finance_objective
     WHERE name = 'TESTE_Aposentadoria';
    pr_delete_finance_objective(v_id);
    dbms_output.put_line('7 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('7 ERRO');
END;
/
BEGIN
    pr_delete_finance_objective(0);
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -21006 THEN
            dbms_output.put_line('8 OK');
        ELSE
            dbms_output.put_line('8 ERRO');
        END IF;
END;
/




-- Tabela Country
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_country (
    p_name         IN p_country.name%TYPE,
    p_abbreviation IN p_country.abbreviation%TYPE
) AS
BEGIN
    INSERT INTO p_country (
        name,
        abbreviation
    ) VALUES ( p_name,
               p_abbreviation );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -22001,
            'Já existe um país com esse nome ou sigla.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -22002,
            'Erro ao inserir país: ' || sqlerrm
        );
END;








-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE pr_update_country (
    p_country_id   IN p_country.country_id%TYPE,
    p_name         IN p_country.name%TYPE,
    p_abbreviation IN p_country.abbreviation%TYPE
) AS
BEGIN
    UPDATE p_country
       SET name = p_name,
           abbreviation = p_abbreviation
     WHERE country_id = p_country_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -22003,
            'Nenhum país encontrado com o ID informado.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -22004,
            'Já existe um país com esse nome ou sigla.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -22005,
            'Erro ao atualizar país: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_update_country (
    p_country_id   IN p_country.country_id%TYPE,
    p_name         IN p_country.name%TYPE,
    p_abbreviation IN p_country.abbreviation%TYPE
) AS
BEGIN
    UPDATE p_country
       SET name = p_name,
           abbreviation = p_abbreviation
     WHERE country_id = p_country_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -22003,
            'Nenhum país encontrado com o ID informado.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -22004,
            'Já existe um país com esse nome ou sigla.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -22005,
            'Erro ao atualizar país: ' || sqlerrm
        );
END;
/

-- ======================================================================

-- Teste

--INSERT
BEGIN
    pr_insert_country(
        'TESTE_Brasil',
        'BR'
    );
    dbms_output.put_line('1 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('1 ERRO');
END;
/
BEGIN
    pr_insert_country(
        'TESTE_Brasil',
        'XX'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -22001 THEN
            dbms_output.put_line('2 OK');
        ELSE
            dbms_output.put_line('2 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_country(
        NULL,
        'YY'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -22002 THEN
            dbms_output.put_line('3 OK');
        ELSE
            dbms_output.put_line('3 ERRO');
        END IF;
END;
/
--UPDATE
DECLARE
    v_id p_country.country_id%TYPE;
BEGIN
    SELECT country_id
      INTO v_id
      FROM p_country
     WHERE name = 'TESTE_Brasil';
    pr_update_country(
        v_id,
        'TESTE_Argentina',
        'AR'
    );
    dbms_output.put_line('4 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('4 ERRO');
END;
/
BEGIN
    pr_update_country(
        0,
        'X',
        'Y'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -22003 THEN
            dbms_output.put_line('5 OK');
        ELSE
            dbms_output.put_line('5 ERRO');
        END IF;
END;
/
BEGIN
    SELECT country_id
      INTO v_id
      FROM p_country
     WHERE name = 'TESTE_Argentina';
    pr_insert_country(
        'TESTE_Chile',
        'CL'
    );
    pr_update_country(
        v_id,
        'TESTE_Chile',
        'XX'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -22004 THEN
            dbms_output.put_line('6 OK');
        ELSE
            dbms_output.put_line('6 ERRO');
        END IF;
END;
/
--DELETE
DECLARE
    v_id p_country.country_id%TYPE;
BEGIN
    SELECT country_id
      INTO v_id
      FROM p_country
     WHERE name = 'TESTE_Argentina';
    pr_delete_country(v_id);
    dbms_output.put_line('7 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('7 ERRO');
END;
/
BEGIN
    pr_delete_country(0);
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -22006 THEN
            dbms_output.put_line('8 OK');
        ELSE
            dbms_output.put_line('8 ERRO');
        END IF;
END;
/

-- Tabela State
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_state (
    p_name         IN p_state.name%TYPE,
    p_abbreviation IN p_state.abbreviation%TYPE
) AS
BEGIN
    INSERT INTO p_state (
        name,
        abbreviation
    ) VALUES ( p_name,
               p_abbreviation );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -23001,
            'Já existe um estado com esse nome ou sigla.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -23002,
            'Erro ao inserir estado: ' || sqlerrm
        );
END;
/

-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE pr_update_state (
    p_state_id     IN p_state.state_id%TYPE,
    p_name         IN p_state.name%TYPE,
    p_abbreviation IN p_state.abbreviation%TYPE
) AS
BEGIN
    UPDATE p_state
       SET name = p_name,
           abbreviation = p_abbreviation
     WHERE state_id = p_state_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -23003,
            'Nenhum estado encontrado com o ID informado.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -23004,
            'Já existe um estado com esse nome ou sigla.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -23005,
            'Erro ao atualizar estado: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_state (
    p_state_id IN p_state.state_id%TYPE
) AS
BEGIN
    DELETE FROM p_state
     WHERE state_id = p_state_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -23006,
            'Nenhum estado encontrado com o ID informado.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -23007,
            'Erro ao remover estado: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Teste


--INSERT
BEGIN
    pr_insert_state(
        'TESTE_São Paulo',
        'SP'
    );
    dbms_output.put_line('1 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('1 ERRO');
END;
/
BEGIN
    pr_insert_state(
        'TESTE_São Paulo',
        'XX'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -23001 THEN
            dbms_output.put_line('2 OK');
        ELSE
            dbms_output.put_line('2 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_state(
        NULL,
        'YY'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -23002 THEN
            dbms_output.put_line('3 OK');
        ELSE
            dbms_output.put_line('3 ERRO');
        END IF;
END;
/
--UPDATE
DECLARE
    v_id p_state.state_id%TYPE;
BEGIN
    SELECT state_id
      INTO v_id
      FROM p_state
     WHERE name = 'TESTE_São Paulo';
    pr_update_state(
        v_id,
        'TESTE_Rio Janeiro',
        'RJ'
    );
    dbms_output.put_line('4 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('4 ERRO');
END;
/
BEGIN
    pr_update_state(
        0,
        'X',
        'Y'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -23003 THEN
            dbms_output.put_line('5 OK');
        ELSE
            dbms_output.put_line('5 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_state(
        'TESTE_Minas Gerais',
        'MG'
    );
    SELECT state_id
      INTO v_id
      FROM p_state
     WHERE name = 'TESTE_Rio Janeiro';
    pr_update_state(
        v_id,
        'TESTE_Minas Gerais',
        'XX'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -23004 THEN
            dbms_output.put_line('6 OK');
        ELSE
            dbms_output.put_line('6 ERRO');
        END IF;
END;
/
--DELETE
DECLARE
    v_id p_state.state_id%TYPE;
BEGIN
    SELECT state_id
      INTO v_id
      FROM p_state
     WHERE name = 'TESTE_Rio Janeiro';
    pr_delete_state(v_id);
    dbms_output.put_line('7 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('7 ERRO');
END;
/
BEGIN
    pr_delete_state(0);
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -23006 THEN
            dbms_output.put_line('8 OK');
        ELSE
            dbms_output.put_line('8 ERRO');
        END IF;
END;
/

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

-- Tabela User
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_user (
    p_full_name            IN p_user.full_name%TYPE,
    p_email                IN p_user.email%TYPE,
    p_hashed_password      IN p_user.hashed_password%TYPE,
    p_time_zone_id         IN p_user.time_zone_id%TYPE,
    p_country_id           IN p_user.country_id%TYPE,
    p_income               IN p_user.income%TYPE DEFAULT NULL,
    p_finance_objective_id IN p_user.finance_objective_id%TYPE DEFAULT NULL,
    p_gender               IN p_user.gender%TYPE DEFAULT NULL,
    p_phone_number         IN p_user.phone_number%TYPE DEFAULT NULL,
    p_birthday             IN p_user.birthday%TYPE DEFAULT NULL,
    p_profile_picture_url  IN p_user.profile_picture_url%TYPE
) AS
    v_validation_result VARCHAR2(200);
BEGIN
    v_validation_result := fn_validate_user_data(
        p_email,
        p_country_id,
        p_time_zone_id,
        p_finance_objective_id,
        p_gender
    );
    IF v_validation_result <> 'VÁLIDO' THEN
        raise_application_error(
            -25000,
            v_validation_result
        );
    END IF;
    INSERT INTO p_user (
        full_name,
        email,
        hashed_password,
        time_zone_id,
        country_id,
        income,
        finance_objective_id,
        gender,
        phone_number,
        birthday,
        profile_picture_url
    ) VALUES ( p_full_name,
               p_email,
               p_hashed_password,
               p_time_zone_id,
               p_country_id,
               p_income,
               p_finance_objective_id,
               p_gender,
               p_phone_number,
               p_birthday,
               p_profile_picture_url );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -25001,
            'Email ou telefone já está em uso.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -25002,
            'Erro ao inserir usuário: ' || sqlerrm
        );
END;


-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE pr_update_user (
    p_user_id              IN p_user.user_id%TYPE,
    p_full_name            IN p_user.full_name%TYPE,
    p_email                IN p_user.email%TYPE,
    p_hashed_password      IN p_user.hashed_password%TYPE,
    p_time_zone_id         IN p_user.time_zone_id%TYPE,
    p_country_id           IN p_user.country_id%TYPE,
    p_income               IN p_user.income%TYPE,
    p_finance_objective_id IN p_user.finance_objective_id%TYPE,
    p_gender               IN p_user.gender%TYPE,
    p_phone_number         IN p_user.phone_number%TYPE,
    p_birthday             IN p_user.birthday%TYPE,
    p_profile_picture_url  IN p_user.profile_picture_url%TYPE
) AS
    v_validation_result VARCHAR2(200);
BEGIN
    v_validation_result := fn_validate_user_data(
        p_email,
        p_country_id,
        p_time_zone_id,
        p_finance_objective_id,
        p_gender
    );
    IF v_validation_result <> 'VÁLIDO' THEN
        raise_application_error(
            -25000,
            v_validation_result
        );
    END IF;
    UPDATE p_user
       SET full_name = p_full_name,
           email = p_email,
           hashed_password = p_hashed_password,
           time_zone_id = p_time_zone_id,
           country_id = p_country_id,
           income = p_income,
           finance_objective_id = p_finance_objective_id,
           gender = p_gender,
           phone_number = p_phone_number,
           birthday = p_birthday,
           profile_picture_url = p_profile_picture_url,
           updated_at = systimestamp
     WHERE user_id = p_user_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -25003,
            'Usuário não encontrado para atualização.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -25004,
            'Email ou telefone já está em uso.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -25005,
            'Erro ao atualizar usuário: ' || sqlerrm
        );
END;



-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_user (
    p_user_id IN p_user.user_id%TYPE
) AS
BEGIN
    DELETE FROM p_user
     WHERE user_id = p_user_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -25006,
            'Usuário não encontrado para remoção.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -25007,
            'Erro ao remover usuário: ' || sqlerrm
        );
END;
/

-- ======================================================================

-- Teste

--INSERT
BEGIN
    pr_insert_user(
        p_full_name            => 'TESTE_Maria Silva',
        p_email                => 'TESTE_maria@teste.com',
        p_hashed_password      => 'HASH123',
        p_time_zone_id         => 1,
        p_country_id           => 1,
        p_income               => 5000,
        p_finance_objective_id => 1,
        p_gender               => 'F',
        p_phone_number         => '11999999999',
        p_birthday             => DATE '1990-05-15',
        p_profile_picture_url  => 'http://foto/maria.jpg'
    );
    dbms_output.put_line('1 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('1 ERRO');
END;
/
BEGIN
    pr_insert_user(
        'TESTE_João',
        'TESTE_maria@teste.com',
        'HASH',
        '1',
        '1'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -25001 THEN
            dbms_output.put_line('2 OK');
        ELSE
            dbms_output.put_line('2 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_user(
        'TESTE_X',
        'x@x.com',
        'HASH',
        '99999',
        '1'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -25002 THEN
            dbms_output.put_line('3 OK');
        ELSE
            dbms_output.put_line('3 ERRO');
        END IF;
END;
/
--UPDATE
DECLARE
    v_id p_user.user_id%TYPE;
BEGIN
    SELECT user_id
      INTO v_id
      FROM p_user
     WHERE email = 'TESTE_maria@teste.com';
    pr_update_user(
        p_user_id              => v_id,
        p_full_name            => 'TESTE_Maria Souza',
        p_email                => 'TESTE_maria.souza@teste.com',
        p_hashed_password      => 'NEWHASH',
        p_time_zone_id         => 1,
        p_country_id           => 1,
        p_income               => 6000,
        p_finance_objective_id => 2,
        p_gender               => 'F',
        p_phone_number         => '11888888888',
        p_birthday             => DATE '1990-05-15',
        p_profile_picture_url  => 'http://foto/maria2.jpg'
    );
    dbms_output.put_line('4 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('4 ERRO');
END;
/
BEGIN
    pr_update_user(
        0,
        'X',
        'x@x.com',
        'H',
        '1',
        '1'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -25003 THEN
            dbms_output.put_line('5 OK');
        ELSE
            dbms_output.put_line('5 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_user(
        'TESTE_Pedro',
        'TESTE_pedro@teste.com',
        'HASH',
        '1',
        '1'
    );
    SELECT user_id
      INTO v_id
      FROM p_user
     WHERE email = 'TESTE_maria.souza@teste.com';
    pr_update_user(
        v_id,
        'X',
        'TESTE_pedro@teste.com',
        'H',
        '1',
        '1'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -25004 THEN
            dbms_output.put_line('6 OK');
        ELSE
            dbms_output.put_line('6 ERRO');
        END IF;
END;
/
--DELETE
DECLARE
    v_id p_user.user_id%TYPE;
BEGIN
    SELECT user_id
      INTO v_id
      FROM p_user
     WHERE email = 'TESTE_maria.souza@teste.com';
    pr_delete_user(v_id);
    dbms_output.put_line('7 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('7 ERRO');
END;
/
BEGIN
    pr_delete_user(0);
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -25006 THEN
            dbms_output.put_line('8 OK');
        ELSE
            dbms_output.put_line('8 ERRO');
        END IF;
END;
/


-- Tabela User Address
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_user_address (
    p_user_id IN p_user_address.user_id%TYPE,
    p_cep     IN p_user_address.cep%TYPE,
    p_city_id IN p_user_address.city_id%TYPE
) AS
BEGIN
    INSERT INTO p_user_address (
        user_id,
        cep,
        city_id
    ) VALUES ( p_user_id,
               p_cep,
               p_city_id );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -26001,
            'Este usuário já possui um endereço cadastrado.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -26002,
            'Erro ao inserir endereço do usuário: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE pr_update_user_address (
    p_user_address_id IN p_user_address.user_address_id%TYPE,
    p_user_id         IN p_user_address.user_id%TYPE,
    p_cep             IN p_user_address.cep%TYPE,
    p_city_id         IN p_user_address.city_id%TYPE
) AS
BEGIN
    UPDATE p_user_address
       SET user_id = p_user_id,
           cep = p_cep,
           city_id = p_city_id,
           updated_at = systimestamp
     WHERE user_address_id = p_user_address_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -26003,
            'Endereço não encontrado para atualização.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -26004,
            'Este usuário já possui outro endereço cadastrado.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -26005,
            'Erro ao atualizar endereço do usuário: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_user_address (
    p_user_address_id IN p_user_address.user_address_id%TYPE
) AS
BEGIN
    DELETE FROM p_user_address
     WHERE user_address_id = p_user_address_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -26006,
            'Endereço não encontrado para remoção.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -26007,
            'Erro ao remover endereço do usuário: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Teste

--INSERT
BEGIN
    pr_insert_user_address(
        1,
        'TESTE_01001-000',
        1
    );
    dbms_output.put_line('1 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('1 ERRO');
END;
/
BEGIN
    pr_insert_user_address(
        1,
        'TESTE_99999-999',
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -26001 THEN
            dbms_output.put_line('2 OK');
        ELSE
            dbms_output.put_line('2 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_user_address(
        1,
        'TESTE_11111-111',
        99999
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -26002 THEN
            dbms_output.put_line('3 OK');
        ELSE
            dbms_output.put_line('3 ERRO');
        END IF;
END;
/
--UPDATE
DECLARE
    v_id p_user_address.user_address_id%TYPE;
BEGIN
    SELECT user_address_id
      INTO v_id
      FROM p_user_address
     WHERE cep = 'TESTE_01001-000';
    pr_update_user_address(
        v_id,
        1,
        'TESTE_20000-000',
        2
    );
    dbms_output.put_line('4 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('4 ERRO');
END;
/
BEGIN
    pr_update_user_address(
        0,
        1,
        'X',
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -26003 THEN
            dbms_output.put_line('5 OK');
        ELSE
            dbms_output.put_line('5 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_user_address(
        2,
        'TESTE_30000-000',
        1
    );
    SELECT user_address_id
      INTO v_id
      FROM p_user_address
     WHERE cep = 'TESTE_20000-000';
    pr_update_user_address(
        v_id,
        2,
        'TESTE_30000-000',
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -26004 THEN
            dbms_output.put_line('6 OK');
        ELSE
            dbms_output.put_line('6 ERRO');
        END IF;
END;
/
--DELETE
DECLARE
    v_id p_user_address.user_address_id%TYPE;
BEGIN
    SELECT user_address_id
      INTO v_id
      FROM p_user_address
     WHERE cep = 'TESTE_20000-000';
    pr_delete_user_address(v_id);
    dbms_output.put_line('7 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('7 ERRO');
END;
/
BEGIN
    pr_delete_user_address(0);
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -26006 THEN
            dbms_output.put_line('8 OK');
        ELSE
            dbms_output.put_line('8 ERRO');
        END IF;
END;
/


-- Tabela Wallet
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_wallet (
    p_user_id     IN p_wallet.user_id%TYPE,
    p_name        IN p_wallet.name%TYPE,
    p_description IN p_wallet.description%TYPE DEFAULT NULL
) AS
BEGIN
    INSERT INTO p_wallet (
        user_id,
        name,
        description
    ) VALUES ( p_user_id,
               p_name,
               p_description );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -27001,
            'O usuário já possui uma carteira com esse nome.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -27002,
            'Erro ao inserir carteira: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE pr_update_wallet (
    p_wallet_id   IN p_wallet.wallet_id%TYPE,
    p_user_id     IN p_wallet.user_id%TYPE,
    p_name        IN p_wallet.name%TYPE,
    p_description IN p_wallet.description%TYPE
) AS
BEGIN
    UPDATE p_wallet
       SET user_id = p_user_id,
           name = p_name,
           description = p_description,
           updated_at = systimestamp
     WHERE wallet_id = p_wallet_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -27003,
            'Carteira não encontrada para atualização.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -27004,
            'O usuário já possui outra carteira com esse nome.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -27005,
            'Erro ao atualizar carteira: ' || sqlerrm
        );
END;
/




-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_wallet (
    p_wallet_id IN p_wallet.wallet_id%TYPE
) AS
BEGIN
    DELETE FROM p_wallet
     WHERE wallet_id = p_wallet_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -27006,
            'Carteira não encontrada para remoção.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Possível erro: FK de transações dentro da carteira
        raise_application_error(
            -27007,
            'Erro ao remover carteira: ' || sqlerrm
        );
END;
/



-- ======================================================================

-- Teste

--INSERT
BEGIN
    pr_insert_wallet(
        1,
        'TESTE_Poupança',
        'Minha reserva de emergência'
    );
    dbms_output.put_line('1 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('1 ERRO');
END;
/
BEGIN
    pr_insert_wallet(
        1,
        'TESTE_Poupança',
        'Duplicada'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27001 THEN
            dbms_output.put_line('2 OK');
        ELSE
            dbms_output.put_line('2 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_wallet(
        99999,
        'TESTE_Inexistente',
        'Usuário inexistente'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27002 THEN
            dbms_output.put_line('3 OK');
        ELSE
            dbms_output.put_line('3 ERRO');
        END IF;
END;
/
--UPDATE
DECLARE
    v_id p_wallet.wallet_id%TYPE;
BEGIN
    SELECT wallet_id
      INTO v_id
      FROM p_wallet
     WHERE name = 'TESTE_Poupança';
    pr_update_wallet(
        v_id,
        1,
        'TESTE_Viagem 2026',
        'Fundo para Europa'
    );
    dbms_output.put_line('4 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('4 ERRO');
END;
/
BEGIN
    pr_update_wallet(
        0,
        1,
        'X',
        'Y'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27003 THEN
            dbms_output.put_line('5 OK');
        ELSE
            dbms_output.put_line('5 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_wallet(
        1,
        'TESTE_Reserva',
        'Reserva de segurança'
    );
    SELECT wallet_id
      INTO v_id
      FROM p_wallet
     WHERE name = 'TESTE_Viagem 2026';
    pr_update_wallet(
        v_id,
        1,
        'TESTE_Reserva',
        'Tentativa duplicar'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27004 THEN
            dbms_output.put_line('6 OK');
        ELSE
            dbms_output.put_line('6 ERRO');
        END IF;
END;
/
--DELETE
DECLARE
    v_id p_wallet.wallet_id%TYPE;
BEGIN
    SELECT wallet_id
      INTO v_id
      FROM p_wallet
     WHERE name = 'TESTE_Viagem 2026';
    pr_delete_wallet(v_id);
    dbms_output.put_line('7 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('7 ERRO');
END;
/
BEGIN
    pr_delete_wallet(0);
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27006 THEN
            dbms_output.put_line('8 OK');
        ELSE
            dbms_output.put_line('8 ERRO');
        END IF;
END;
/


-- Tabela Account Icon
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_account_icon (
    p_name  IN p_account_icon.name%TYPE,
    p_label IN p_account_icon.label%TYPE,
    p_url   IN p_account_icon.url%TYPE
) AS
BEGIN
    INSERT INTO p_account_icon (
        name,
        label,
        url
    ) VALUES ( p_name,
               p_label,
               p_url );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -27010,
            'Já existe um ícone com esse nome, label ou URL.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -27011,
            'Erro ao inserir ícone: ' || sqlerrm
        );
END;
/





-- ======================================================================

-- Update
CREATE OR REPLACE PROCEDURE pr_update_account_icon (
    p_account_icon_id IN p_account_icon.account_icon_id%TYPE,
    p_name            IN p_account_icon.name%TYPE,
    p_label           IN p_account_icon.label%TYPE,
    p_url             IN p_account_icon.url%TYPE
) AS
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO v_exists
      FROM p_account_icon
     WHERE account_icon_id = p_account_icon_id;

    IF v_exists = 0 THEN
        raise_application_error(
            -27012,
            'Ícone não encontrado para atualização.'
        );
    END IF;
    UPDATE p_account_icon
       SET name = p_name,
           label = p_label,
           url = p_url
     WHERE account_icon_id = p_account_icon_id;

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -27013,
            'Já existe um ícone com esse nome, label ou URL.'
        );
END;


-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_account_icon (
    p_account_icon_id IN p_account_icon.account_icon_id%TYPE
) AS
BEGIN
    DELETE FROM p_account_icon
     WHERE account_icon_id = p_account_icon_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -27015,
            'Ícone não encontrado para remoção.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -27016,
            'Erro ao remover ícone: ' || sqlerrm
        );
END;
/


-- Tabela Account Type
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_account_type (
    p_name     IN p_account_type.name%TYPE,
    p_label    IN p_account_type.label%TYPE,
    p_behavior IN p_account_type.behavior%TYPE
) AS
BEGIN
    INSERT INTO p_account_type (
        name,
        label,
        behavior
    ) VALUES ( p_name,
               p_label,
               p_behavior );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -27020,
            'Já existe um tipo de conta com esse nome ou label.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -27021,
            'Erro ao inserir tipo de conta: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Update
CREATE OR REPLACE PROCEDURE pr_update_account_type (
    p_account_type_id IN p_account_type.account_type_id%TYPE,
    p_name            IN p_account_type.name%TYPE,
    p_label           IN p_account_type.label%TYPE,
    p_behavior        IN p_account_type.behavior%TYPE
) AS
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO v_exists
      FROM p_account_type
     WHERE account_type_id = p_account_type_id;

    IF v_exists = 0 THEN
        raise_application_error(
            -27022,
            'Tipo de conta não encontrado para atualização.'
        );
    END IF;
    UPDATE p_account_type
       SET name = p_name,
           label = p_label,
           behavior = p_behavior
     WHERE account_type_id = p_account_type_id;

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -27023,
            'Já existe um tipo de conta com esse nome ou label.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -27024,
            'Erro ao atualizar tipo de conta: ' || sqlerrm
        );
END;
/




-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_account_type (
    p_account_type_id IN p_account_type.account_type_id%TYPE
) AS
BEGIN
    DELETE FROM p_account_type
     WHERE account_type_id = p_account_type_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -27025,
            'Tipo de conta não encontrado para remoção.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -27026,
            'Erro ao remover tipo de conta: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Teste

--INSERT
BEGIN
    pr_insert_account_type(
        'TESTE_Corrente',
        'Conta Corrente',
        'DEBIT'
    );
    dbms_output.put_line('1 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('1 ERRO');
END;
/
BEGIN
    pr_insert_account_type(
        'TESTE_Corrente',
        'Outra',
        'DEBIT'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27020 THEN
            dbms_output.put_line('2 OK');
        ELSE
            dbms_output.put_line('2 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_account_type(
        NULL,
        'Invalida',
        'X'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27021 THEN
            dbms_output.put_line('3 OK');
        ELSE
            dbms_output.put_line('3 ERRO');
        END IF;
END;
/
--UPDATE
DECLARE
    v_id p_account_type.account_type_id%TYPE;
BEGIN
    SELECT account_type_id
      INTO v_id
      FROM p_account_type
     WHERE name = 'TESTE_Corrente';
    pr_update_account_type(
        v_id,
        'TESTE_Poupança',
        'Poupança',
        'CREDIT'
    );
    dbms_output.put_line('4 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('4 ERRO');
END;
/
BEGIN
    pr_update_account_type(
        0,
        'X',
        'Y',
        'Z'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27022 THEN
            dbms_output.put_line('5 OK');
        ELSE
            dbms_output.put_line('5 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_account_type(
        'TESTE_Investimento',
        'Invest',
        'INVEST'
    );
    SELECT account_type_id
      INTO v_id
      FROM p_account_type
     WHERE name = 'TESTE_Poupança';
    pr_update_account_type(
        v_id,
        'TESTE_Investimento',
        'Invest',
        'INVEST'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27023 THEN
            dbms_output.put_line('6 OK');
        ELSE
            dbms_output.put_line('6 ERRO');
        END IF;
END;
/
--DELETE
DECLARE
    v_id p_account_type.account_type_id%TYPE;
BEGIN
    SELECT account_type_id
      INTO v_id
      FROM p_account_type
     WHERE name = 'TESTE_Poupança';
    pr_delete_account_type(v_id);
    dbms_output.put_line('7 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('7 ERRO');
END;
/
BEGIN
    pr_delete_account_type(0);
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27025 THEN
            dbms_output.put_line('8 OK');
        ELSE
            dbms_output.put_line('8 ERRO');
        END IF;
END;
/


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
            -27030,
            'Já existe um banco com esse nome ou código.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -27031,
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
            -27032,
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
            -27033,
            'Já existe um banco com esse nome ou código.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -27034,
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
            -27035,
            'Banco não encontrado para remoção.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -27036,
            'Erro ao remover banco: ' || sqlerrm
        );
END;
/



-- ======================================================================

-- Teste

--INSERT
BEGIN
    pr_insert_bank(
        'TESTE_Nubank',
        '260',
        'https://nubank.com.br/logo.png'
    );
    dbms_output.put_line('1 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('1 ERRO');
END;
/
BEGIN
    pr_insert_bank(
        'TESTE_Nubank',
        '999',
        'Duplicado'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27030 THEN
            dbms_output.put_line('2 OK');
        ELSE
            dbms_output.put_line('2 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_bank(
        NULL,
        '001',
        'Invalido'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27031 THEN
            dbms_output.put_line('3 OK');
        ELSE
            dbms_output.put_line('3 ERRO');
        END IF;
END;
/
--UPDATE
DECLARE
    v_id p_bank.bank_id%TYPE;
BEGIN
    SELECT bank_id
      INTO v_id
      FROM p_bank
     WHERE name = 'TESTE_Nubank';
    pr_update_bank(
        v_id,
        'TESTE_Inter',
        '077',
        'https://inter.co/logo.png'
    );
    dbms_output.put_line('4 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('4 ERRO');
END;
/
BEGIN
    pr_update_bank(
        0,
        'X',
        '000',
        ''
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27032 THEN
            dbms_output.put_line('5 OK');
        ELSE
            dbms_output.put_line('5 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_bank(
        'TESTE_Bradesco',
        '237',
        'https://bradesco.com.br'
    );
    SELECT bank_id
      INTO v_id
      FROM p_bank
     WHERE name = 'TESTE_Inter';
    pr_update_bank(
        v_id,
        'TESTE_Bradesco',
        '237',
        'duplicate'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27033 THEN
            dbms_output.put_line('6 OK');
        ELSE
            dbms_output.put_line('6 ERRO');
        END IF;
END;
/
--DELETE
DECLARE
    v_id p_bank.bank_id%TYPE;
BEGIN
    SELECT bank_id
      INTO v_id
      FROM p_bank
     WHERE name = 'TESTE_Inter';
    pr_delete_bank(v_id);
    dbms_output.put_line('7 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('7 ERRO');
END;
/
BEGIN
    pr_delete_bank(0);
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27035 THEN
            dbms_output.put_line('8 OK');
        ELSE
            dbms_output.put_line('8 ERRO');
        END IF;
END;
/


-- Tabela Account
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_account (
    p_wallet_id       IN p_account.wallet_id%TYPE,
    p_name            IN p_account.name%TYPE,
    p_account_type_id IN p_account.account_type_id%TYPE,
    p_bank_id         IN p_account.bank_id%TYPE,
    p_balance         IN p_account.balance%TYPE DEFAULT 0,
    p_overdraft       IN p_account.overdraft%TYPE DEFAULT 0,
    p_color_id        IN p_account.color_id%TYPE,
    p_account_icon_id IN p_account.account_icon_id%TYPE
) AS
BEGIN
    INSERT INTO p_account (
        wallet_id,
        name,
        account_type_id,
        bank_id,
        balance,
        overdraft,
        color_id,
        account_icon_id
    ) VALUES ( p_wallet_id,
               p_name,
               p_account_type_id,
               p_bank_id,
               p_balance,
               p_overdraft,
               p_color_id,
               p_account_icon_id );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -27040,
            'Já existe uma conta com esse nome nesta carteira.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -27041,
            'Erro ao inserir conta: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE pr_update_account (
    p_account_id      IN p_account.account_id%TYPE,
    p_name            IN p_account.name%TYPE,
    p_account_type_id IN p_account.account_type_id%TYPE,
    p_bank_id         IN p_account.bank_id%TYPE,
    p_balance         IN p_account.balance%TYPE,
    p_overdraft       IN p_account.overdraft%TYPE,
    p_color_id        IN p_account.color_id%TYPE,
    p_account_icon_id IN p_account.account_icon_id%TYPE
) AS
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO v_exists
      FROM p_account
     WHERE account_id = p_account_id;

    IF v_exists = 0 THEN
        raise_application_error(
            -27042,
            'Conta não encontrada para atualização.'
        );
    END IF;
    UPDATE p_account
       SET name = p_name,
           account_type_id = p_account_type_id,
           bank_id = p_bank_id,
           balance = p_balance,
           overdraft = p_overdraft,
           color_id = p_color_id,
           account_icon_id = p_account_icon_id,
           updated_at = systimestamp
     WHERE account_id = p_account_id;

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -27043,
            'Já existe uma conta com esse nome nesta carteira.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -27044,
            'Erro ao atualizar conta: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_account (
    p_account_id IN p_account.account_id%TYPE
) AS
BEGIN
    DELETE FROM p_account
     WHERE account_id = p_account_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -27045,
            'Conta não encontrada para remoção.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Possível FK: transações dependentes
        raise_application_error(
            -27046,
            'Erro ao remover conta: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Teste

--INSERT
BEGIN
    pr_insert_account(
        1,
        'TESTE_NuConta',
        1,
        1,
        5000,
        1000,
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
    pr_insert_account(
        1,
        'TESTE_NuConta',
        1,
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27040 THEN
            dbms_output.put_line('2 OK');
        ELSE
            dbms_output.put_line('2 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_account(
        99999,
        'TESTE_FK',
        1,
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27041 THEN
            dbms_output.put_line('3 OK');
        ELSE
            dbms_output.put_line('3 ERRO');
        END IF;
END;
/
--UPDATE
DECLARE
    v_id p_account.account_id%TYPE;
BEGIN
    SELECT account_id
      INTO v_id
      FROM p_account
     WHERE name = 'TESTE_NuConta';
    pr_update_account(
        v_id,
        'TESTE_Inter',
        2,
        2,
        8000,
        2000,
        2,
        2
    );
    dbms_output.put_line('4 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('4 ERRO');
END;
/
BEGIN
    pr_update_account(
        0,
        'X',
        1,
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27042 THEN
            dbms_output.put_line('5 OK');
        ELSE
            dbms_output.put_line('5 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_account(
        1,
        'TESTE_Reserva',
        1,
        1
    );
    SELECT account_id
      INTO v_id
      FROM p_account
     WHERE name = 'TESTE_Inter';
    pr_update_account(
        v_id,
        'TESTE_Reserva',
        1,
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27043 THEN
            dbms_output.put_line('6 OK');
        ELSE
            dbms_output.put_line('6 ERRO');
        END IF;
END;
/
--DELETE
DECLARE
    v_id p_account.account_id%TYPE;
BEGIN
    SELECT account_id
      INTO v_id
      FROM p_account
     WHERE name = 'TESTE_Inter';
    pr_delete_account(v_id);
    dbms_output.put_line('7 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('7 ERRO');
END;
/
BEGIN
    pr_delete_account(0);
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27045 THEN
            dbms_output.put_line('8 OK');
        ELSE
            dbms_output.put_line('8 ERRO');
        END IF;
END;
/


-- Tabela Transfer
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_transfer (
    p_value                  IN p_transfer.value%TYPE,
    p_origin_account_id      IN p_transfer.origin_account_id%TYPE,
    p_destination_account_id IN p_transfer.destination_account_id%TYPE,
    p_description            IN p_transfer.description%TYPE
) AS
    v_origin_balance NUMBER;
BEGIN
    IF p_origin_account_id = p_destination_account_id THEN
        raise_application_error(
            -27050,
            'A conta de origem não pode ser igual à conta de destino.'
        );
    END IF;

    -- Verifica se a conta de origem existe e obtém saldo
    SELECT balance
      INTO v_origin_balance
      FROM p_account
     WHERE account_id = p_origin_account_id
    FOR UPDATE;

    -- Verifica destino
    SELECT COUNT(*)
      INTO v_origin_balance
      FROM p_account
     WHERE account_id = p_destination_account_id;

    IF v_origin_balance = 0 THEN
        raise_application_error(
            -27051,
            'Conta de destino inexistente.'
        );
    END IF;

    -- Verifica limite
    IF v_origin_balance < p_value THEN
        raise_application_error(
            -27052,
            'Saldo insuficiente para transferência.'
        );
    END IF;

    -- Debita da origem
    UPDATE p_account
       SET balance = balance - p_value,
           updated_at = systimestamp
     WHERE account_id = p_origin_account_id;

    -- Credita no destino
    UPDATE p_account
       SET balance = balance + p_value,
           updated_at = systimestamp
     WHERE account_id = p_destination_account_id;

    -- Registra a transferência
    INSERT INTO p_transfer (
        value,
        origin_account_id,
        destination_account_id,
        description
    ) VALUES ( p_value,
               p_origin_account_id,
               p_destination_account_id,
               p_description );

    COMMIT;
EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(
            -27053,
            'Conta de origem não encontrada.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -27054,
            'Erro ao registrar transferência: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE pr_update_transfer (
    p_transfer_id IN p_transfer.transfer_id%TYPE,
    p_description IN p_transfer.description%TYPE
) AS
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO v_exists
      FROM p_transfer
     WHERE transfer_id = p_transfer_id;

    IF v_exists = 0 THEN
        raise_application_error(
            -27055,
            'Transferência não encontrada para atualização.'
        );
    END IF;
    UPDATE p_transfer
       SET description = p_description,
           updated_at = systimestamp
     WHERE transfer_id = p_transfer_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -27056,
            'Erro ao atualizar transferência: ' || sqlerrm
        );
END;


-- ======================================================================

-- Cancel

CREATE OR REPLACE PROCEDURE pr_cancel_transfer (
    p_transfer_id IN p_transfer.transfer_id%TYPE
) AS
    v_value       NUMBER;
    v_origin      NUMBER;
    v_destination NUMBER;
BEGIN
    SELECT value,
           origin_account_id,
           destination_account_id
      INTO
        v_value,
        v_origin,
        v_destination
      FROM p_transfer
     WHERE transfer_id = p_transfer_id
    FOR UPDATE;

    -- Estorna saldo
    UPDATE p_account
       SET balance = balance + v_value,
           updated_at = systimestamp
     WHERE account_id = v_origin;

    UPDATE p_account
       SET balance = balance - v_value,
           updated_at = systimestamp
     WHERE account_id = v_destination;

    -- Opcional: registrar estorno -> você decide
    DELETE FROM p_transfer
     WHERE transfer_id = p_transfer_id;

    COMMIT;
EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(
            -27057,
            'Transferência não encontrada para cancelamento.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -27058,
            'Erro ao cancelar transferência: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Teste

--INSERT
BEGIN
    pr_insert_transfer(
        500,
        1,
        2,
        'TESTE_Transferência OK'
    );
    dbms_output.put_line('1 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('1 ERRO');
END;
/
BEGIN
    pr_insert_transfer(
        500,
        1,
        1,
        'TESTE_Mesma conta'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27050 THEN
            dbms_output.put_line('2 OK');
        ELSE
            dbms_output.put_line('2 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_transfer(
        15000,
        1,
        2,
        'TESTE_Saldo insuficiente'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27052 THEN
            dbms_output.put_line('3 OK');
        ELSE
            dbms_output.put_line('3 ERRO');
        END IF;
END;
/
BEGIN
    pr_insert_transfer(
        100,
        99999,
        2,
        'TESTE_Origem inexistente'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27053 THEN
            dbms_output.put_line('4 OK');
        ELSE
            dbms_output.put_line('4 ERRO');
        END IF;
END;
/
--UPDATE
DECLARE
    v_id p_transfer.transfer_id%TYPE;
BEGIN
    SELECT transfer_id
      INTO v_id
      FROM p_transfer
     WHERE description = 'TESTE_Transferência OK';
    pr_update_transfer(
        v_id,
        'TESTE_Descrição atualizada'
    );
    dbms_output.put_line('5 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('5 ERRO');
END;
/
BEGIN
    pr_update_transfer(
        0,
        'X'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27055 THEN
            dbms_output.put_line('6 OK');
        ELSE
            dbms_output.put_line('6 ERRO');
        END IF;
END;
/
--CANCEL
DECLARE
    v_id p_transfer.transfer_id%TYPE;
BEGIN
    SELECT transfer_id
      INTO v_id
      FROM p_transfer
     WHERE description = 'TESTE_Descrição atualizada';
    pr_cancel_transfer(v_id);
    dbms_output.put_line('7 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('7 ERRO');
END;
/
BEGIN
    pr_cancel_transfer(0);
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -27057 THEN
            dbms_output.put_line('8 OK');
        ELSE
            dbms_output.put_line('8 ERRO');
        END IF;
END;
/


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



-- Tabela Transaction
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_transaction (
    p_value               IN p_transaction.value%TYPE,
    p_description         IN p_transaction.description%TYPE,
    p_transaction_date    IN p_transaction.transaction_date%TYPE DEFAULT sysdate,
    p_has_occurred        IN p_transaction.has_occurred%TYPE DEFAULT 1,
    p_is_auto_confirmed   IN p_transaction.is_auto_confirmed%TYPE DEFAULT 0,
    p_observation         IN p_transaction.observation%TYPE,
    p_account_id          IN p_transaction.account_id%TYPE,
    p_transaction_icon_id IN p_transaction.transaction_icon_id%TYPE,
    p_color_id            IN p_transaction.color_id%TYPE
) AS
    v_validation_result VARCHAR2(200);
BEGIN
    v_validation_result := fn_validate_transaction(
        p_account_id,
        p_value,
        p_transaction_icon_id,
        p_color_id
    );
    IF v_validation_result <> 'VÁLIDO' THEN
        raise_application_error(
            -20100,
            v_validation_result
        );
    END IF;
    INSERT INTO p_transaction (
        value,
        description,
        transaction_date,
        has_occurred,
        is_auto_confirmed,
        observation,
        account_id,
        transaction_icon_id,
        color_id
    ) VALUES ( p_value,
               p_description,
               p_transaction_date,
               p_has_occurred,
               p_is_auto_confirmed,
               p_observation,
               p_account_id,
               p_transaction_icon_id,
               p_color_id );

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20101,
            'Erro ao inserir transação: ' || sqlerrm
        );
END;


-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE pr_update_transaction (
    p_transaction_id      IN p_transaction.transaction_id%TYPE,
    p_value               IN p_transaction.value%TYPE,
    p_description         IN p_transaction.description%TYPE,
    p_transaction_date    IN p_transaction.transaction_date%TYPE,
    p_has_occurred        IN p_transaction.has_occurred%TYPE,
    p_is_auto_confirmed   IN p_transaction.is_auto_confirmed%TYPE,
    p_observation         IN p_transaction.observation%TYPE,
    p_account_id          IN p_transaction.account_id%TYPE,
    p_transaction_icon_id IN p_transaction.transaction_icon_id%TYPE,
    p_color_id            IN p_transaction.color_id%TYPE
) AS
    v_validation_result VARCHAR2(200);
BEGIN
    v_validation_result := fn_validate_transaction(
        p_account_id,
        p_value,
        p_transaction_icon_id,
        p_color_id
    );
    IF v_validation_result <> 'VÁLIDO' THEN
        raise_application_error(
            -20100,
            v_validation_result
        );
    END IF;
    UPDATE p_transaction
       SET value = p_value,
           description = p_description,
           transaction_date = p_transaction_date,
           has_occurred = p_has_occurred,
           is_auto_confirmed = p_is_auto_confirmed,
           observation = p_observation,
           account_id = p_account_id,
           transaction_icon_id = p_transaction_icon_id,
           color_id = p_color_id,
           updated_at = systimestamp
     WHERE transaction_id = p_transaction_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20102,
            'Transação não encontrada para atualização.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20103,
            'Erro ao atualizar transação: ' || sqlerrm
        );
END;


-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_transaction (
    p_transaction_id IN p_transaction.transaction_id%TYPE
) AS
BEGIN
    DELETE FROM p_transaction
     WHERE transaction_id = p_transaction_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20104,
            'Transação não encontrada para exclusão.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20105,
            'Erro ao excluir transação: ' || sqlerrm
        );
END;
/




-- ======================================================================

-- Teste

--INSERT
BEGIN
    pr_insert_transaction(
        p_value               => 89.90,
        p_description         => 'TESTE_Supermercado',
        p_account_id          => 1,
        p_transaction_icon_id => 1,
        p_color_id            => 1
    );
    dbms_output.put_line('1 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('1 ERRO');
END;
/
BEGIN
    pr_insert_transaction(
        50,
        'TESTE_FK',
        99999,
        1,
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -20101 THEN
            dbms_output.put_line('2 OK');
        ELSE
            dbms_output.put_line('2 ERRO');
        END IF;
END;
/
--UPDATE
DECLARE
    v_id p_transaction.transaction_id%TYPE;
BEGIN
    SELECT transaction_id
      INTO v_id
      FROM p_transaction
     WHERE description = 'TESTE_Supermercado';
    pr_update_transaction(
        p_transaction_id      => v_id,
        p_value               => 95.50,
        p_description         => 'TESTE_Supermercado Atualizado',
        p_account_id          => 1,
        p_transaction_icon_id => 1,
        p_color_id            => 1
    );
    dbms_output.put_line('3 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('3 ERRO');
END;
/
BEGIN
    pr_update_transaction(
        0,
        10,
        'X',
        1,
        1,
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -20102 THEN
            dbms_output.put_line('4 OK');
        ELSE
            dbms_output.put_line('4 ERRO');
        END IF;
END;
/
--DELETE
DECLARE
    v_id p_transaction.transaction_id%TYPE;
BEGIN
    SELECT transaction_id
      INTO v_id
      FROM p_transaction
     WHERE description = 'TESTE_Supermercado Atualizado';
    pr_delete_transaction(v_id);
    dbms_output.put_line('5 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('5 ERRO');
END;
/
BEGIN
    pr_delete_transaction(0);
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -20104 THEN
            dbms_output.put_line('6 OK');
        ELSE
            dbms_output.put_line('6 ERRO');
        END IF;
END;
/
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
    dbms_output.put_line('1 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('1 ERRO');
END;
/
BEGIN
    pr_insert_category_icon(
        'TESTE_Alimentação',
        '/cat/other.svg'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -20201 THEN
            dbms_output.put_line('2 OK');
        ELSE
            dbms_output.put_line('2 ERRO');
        END IF;
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
    dbms_output.put_line('3 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('3 ERRO');
END;
/
BEGIN
    pr_update_category_icon(
        0,
        'X',
        'Y'
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -20202 THEN
            dbms_output.put_line('4 OK');
        ELSE
            dbms_output.put_line('4 ERRO');
        END IF;
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
    dbms_output.put_line('5 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('5 ERRO');
END;
/
BEGIN
    pr_delete_category_icon(0);
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -20204 THEN
            dbms_output.put_line('6 OK');
        ELSE
            dbms_output.put_line('6 ERRO');
        END IF;
END;


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
    dbms_output.put_line('1 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('1 ERRO');
END;
/
BEGIN
    pr_insert_transaction_category(
        99999,
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -20401 THEN
            dbms_output.put_line('2 OK');
        ELSE
            dbms_output.put_line('2 ERRO');
        END IF;
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
BEGIN
    pr_update_transaction_category(
        999,
        999,
        1,
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -20402 THEN
            dbms_output.put_line('4 OK');
        ELSE
            dbms_output.put_line('4 ERRO');
        END IF;
END;
/
--DELETE
BEGIN
    pr_delete_transaction_category(
        1,
        2
    );
    dbms_output.put_line('5 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('5 ERRO');
END;
/
BEGIN
    pr_delete_transaction_category(
        999,
        999
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -20404 THEN
            dbms_output.put_line('6 OK');
        ELSE
            dbms_output.put_line('6 ERRO');
        END IF;
END;

-- Tabela Budget
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_budget (
    p_user_id     IN p_budget.user_id%TYPE,
    p_name        IN p_budget.name%TYPE,
    p_category_id IN p_budget.category_id%TYPE,
    p_start_date  IN p_budget.start_date%TYPE,
    p_end_date    IN p_budget.end_date%TYPE,
    p_limit_value IN p_budget.limit_value%TYPE
) AS
BEGIN
    INSERT INTO p_budget (
        user_id,
        name,
        category_id,
        start_date,
        end_date,
        limit_value
    ) VALUES ( p_user_id,
               p_name,
               p_category_id,
               p_start_date,
               p_end_date,
               p_limit_value );

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20501,
            'Erro ao inserir orçamento: ' || sqlerrm
        );
END;


-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE pr_update_budget (
    p_budget_id   IN p_budget.budget_id%TYPE,
    p_user_id     IN p_budget.user_id%TYPE,
    p_name        IN p_budget.name%TYPE,
    p_category_id IN p_budget.category_id%TYPE,
    p_start_date  IN p_budget.start_date%TYPE,
    p_end_date    IN p_budget.end_date%TYPE,
    p_limit_value IN p_budget.limit_value%TYPE
) AS
BEGIN
    UPDATE p_budget
       SET user_id = p_user_id,
           name = p_name,
           category_id = p_category_id,
           start_date = p_start_date,
           end_date = p_end_date,
           limit_value = p_limit_value,
           updated_at = systimestamp
     WHERE budget_id = p_budget_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20502,
            'Orçamento não encontrado para atualização.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20503,
            'Erro ao atualizar orçamento: ' || sqlerrm
        );
END;
/



-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_budget (
    p_budget_id IN p_budget.budget_id%TYPE
) AS
BEGIN
    DELETE FROM p_budget
     WHERE budget_id = p_budget_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20504,
            'Orçamento não encontrado para exclusão.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20505,
            'Erro ao excluir orçamento: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Teste


--INSERT
BEGIN
    pr_insert_budget(
        1,
        'TESTE_Alimentação Mensal',
        1,
        DATE '2025-11-01',
        DATE '2025-11-30',
        1500
    );
    dbms_output.put_line('1 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('1 ERRO');
END;
/
BEGIN
    pr_insert_budget(
        99999,
        'TESTE_FK',
        999,
        DATE '2025-12-01',
        DATE '2025-12-31',
        1000
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -20501 THEN
            dbms_output.put_line('2 OK');
        ELSE
            dbms_output.put_line('2 ERRO');
        END IF;
END;
/
--UPDATE
DECLARE
    v_id p_budget.budget_id%TYPE;
BEGIN
    SELECT budget_id
      INTO v_id
      FROM p_budget
     WHERE name = 'TESTE_Alimentação Mensal';
    pr_update_budget(
        v_id,
        1,
        'TESTE_Transporte Dezembro',
        2,
        DATE '2025-12-01',
        DATE '2025-12-31',
        800
    );
    dbms_output.put_line('3 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('3 ERRO');
END;
/
BEGIN
    pr_update_budget(
        0,
        1,
        'X',
        1,
        DATE '2025-01-01',
        DATE '2025-01-31',
        100
    );
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -20502 THEN
            dbms_output.put_line('4 OK');
        ELSE
            dbms_output.put_line('4 ERRO');
        END IF;
END;
/
--DELETE
DECLARE
    v_id p_budget.budget_id%TYPE;
BEGIN
    SELECT budget_id
      INTO v_id
      FROM p_budget
     WHERE name = 'TESTE_Transporte Dezembro';
    pr_delete_budget(v_id);
    dbms_output.put_line('5 OK');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('5 ERRO');
END;
/
BEGIN
    pr_delete_budget(0);
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -20504 THEN
            dbms_output.put_line('6 OK');
        ELSE
            dbms_output.put_line('6 ERRO');
        END IF;
END;

-- Tabela Functionality
-- Insert

CREATE OR REPLACE PROCEDURE sp_insert_functionality (
    p_name IN p_functionality.name%TYPE,
    p_code IN p_functionality.code%TYPE
) AS
BEGIN
    INSERT INTO p_functionality (
        name,
        code
    ) VALUES ( p_name,
               p_code );

    dbms_output.put_line('Functionality added successfully.');
EXCEPTION
    WHEN dup_val_on_index THEN
        dbms_output.put_line('Error: A functionality with this name or code already exists.');
    WHEN OTHERS THEN
        dbms_output.put_line('Unexpected error: ' || sqlerrm);
END;


-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE sp_update_functionality (
    p_functionality_id IN p_functionality.functionality_id%TYPE,
    p_name             IN p_functionality.name%TYPE,
    p_code             IN p_functionality.code%TYPE
) AS
BEGIN
    UPDATE p_functionality
       SET name = p_name,
           code = p_code
     WHERE functionality_id = p_functionality_id;

    IF SQL%rowcount = 0 THEN
        dbms_output.put_line('No record found with the provided ID.');
    ELSE
        dbms_output.put_line('Functionality updated successfully.');
    END IF;

EXCEPTION
    WHEN dup_val_on_index THEN
        dbms_output.put_line('Error: A functionality with this name or code already exists.');
    WHEN OTHERS THEN
        dbms_output.put_line('Unexpected error: ' || sqlerrm);
END;


-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE sp_delete_functionality (
    p_functionality_id IN p_functionality.functionality_id%TYPE
) AS
BEGIN
    DELETE FROM p_functionality
     WHERE functionality_id = p_functionality_id;

    IF SQL%rowcount = 0 THEN
        dbms_output.put_line('No record found with the provided ID.');
    ELSE
        dbms_output.put_line('Functionality deleted successfully.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Unexpected error: ' || sqlerrm);
END;


-- ======================================================================

-- Teste

--INSERT
BEGIN
    sp_insert_functionality(
        'TESTE_Transferência',
        'TRANSFER'
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
BEGIN
    sp_insert_functionality(
        'TESTE_Transferência',
        'TRANSFER_DUPLICADO'
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
--UPDATE
DECLARE
    v_id p_functionality.functionality_id%TYPE;
BEGIN
    SELECT functionality_id
      INTO v_id
      FROM p_functionality
     WHERE name = 'TESTE_Transferência';
    sp_update_functionality(
        v_id,
        'TESTE_Orçamento',
        'BUDGET'
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
BEGIN
    sp_update_functionality(
        999999,
        'X',
        'Y'
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
--DELETE
DECLARE
    v_id p_functionality.functionality_id%TYPE;
BEGIN
    SELECT functionality_id
      INTO v_id
      FROM p_functionality
     WHERE name = 'TESTE_Orçamento';
    sp_delete_functionality(v_id);
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
BEGIN
    sp_delete_functionality(999999);
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/



-- Tabela Subscription Tier
-- Insert

CREATE OR REPLACE PROCEDURE sp_insert_subscription_tier (
    p_name        IN p_subscription_tier.name%TYPE,
    p_description IN p_subscription_tier.description%TYPE,
    p_price       IN p_subscription_tier.price%TYPE
) AS
BEGIN
    INSERT INTO p_subscription_tier (
        name,
        description,
        price
    ) VALUES ( p_name,
               p_description,
               p_price );

    dbms_output.put_line('Subscription tier inserted successfully.');
EXCEPTION
    WHEN dup_val_on_index THEN
        dbms_output.put_line('Error: A subscription tier with this name already exists.');
    WHEN OTHERS THEN
        dbms_output.put_line('Unexpected error: ' || sqlerrm);
END;


-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE sp_update_subscription_tier (
    p_subscription_tier_id IN p_subscription_tier.subscription_tier_id%TYPE,
    p_name                 IN p_subscription_tier.name%TYPE,
    p_description          IN p_subscription_tier.description%TYPE,
    p_price                IN p_subscription_tier.price%TYPE
) AS
BEGIN
    UPDATE p_subscription_tier
       SET name = p_name,
           description = p_description,
           price = p_price
     WHERE subscription_tier_id = p_subscription_tier_id;

    IF SQL%rowcount = 0 THEN
        dbms_output.put_line('No subscription tier found with the provided ID.');
    ELSE
        dbms_output.put_line('Subscription tier updated successfully.');
    END IF;
EXCEPTION
    WHEN dup_val_on_index THEN
        dbms_output.put_line('Error: A subscription tier with this name already exists.');
    WHEN OTHERS THEN
        dbms_output.put_line('Unexpected error: ' || sqlerrm);
END;


-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE sp_delete_subscription_tier (
    p_subscription_tier_id IN p_subscription_tier.subscription_tier_id%TYPE
) AS
BEGIN
    DELETE FROM p_subscription_tier
     WHERE subscription_tier_id = p_subscription_tier_id;

    IF SQL%rowcount = 0 THEN
        dbms_output.put_line('No subscription tier found with the provided ID.');
    ELSE
        dbms_output.put_line('Subscription tier deleted successfully.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Unexpected error: ' || sqlerrm);
END;


-- ======================================================================

-- Teste

-- INSERT
BEGIN
    sp_insert_subscription_tier(
        'TESTE_Básico',
        'Plano mensal básico',
        29.90
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
BEGIN
    sp_insert_subscription_tier(
        'TESTE_Básico',
        'Tentativa duplicada',
        39.90
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
--UPDATE
DECLARE
    v_id p_subscription_tier.subscription_tier_id%TYPE;
BEGIN
    SELECT subscription_tier_id
      INTO v_id
      FROM p_subscription_tier
     WHERE name = 'TESTE_Básico';
    sp_update_subscription_tier(
        v_id,
        'TESTE_Premium',
        'Plano anual com descontos',
        299.90
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
BEGIN
    sp_update_subscription_tier(
        999999,
        'X',
        'Inexistente',
        0
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
--DELETE
DECLARE
    v_id p_subscription_tier.subscription_tier_id%TYPE;
BEGIN
    SELECT subscription_tier_id
      INTO v_id
      FROM p_subscription_tier
     WHERE name = 'TESTE_Premium';
    sp_delete_subscription_tier(v_id);
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
BEGIN
    sp_delete_subscription_tier(999999);
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/

-- Tabela Category Tier Functionality
-- Insert

CREATE OR REPLACE PROCEDURE sp_insert_category_tier_functionality (
    p_subscription_tier_id IN p_category_tier_functionality.subscription_tier_id%TYPE,
    p_functionality_id     IN p_category_tier_functionality.functionality_id%TYPE
) AS
BEGIN
    INSERT INTO p_category_tier_functionality (
        subscription_tier_id,
        functionality_id
    ) VALUES ( p_subscription_tier_id,
               p_functionality_id );

    dbms_output.put_line('Relação entre Tier e Funcionalidade criada com sucesso.');
EXCEPTION
    WHEN dup_val_on_index THEN
        dbms_output.put_line('Erro: Essa funcionalidade já está vinculada a este tier.');
    WHEN OTHERS THEN
        dbms_output.put_line('Erro inesperado: ' || sqlerrm);
END;

-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE sp_delete_category_tier_functionality (
    p_subscription_tier_id IN p_category_tier_functionality.subscription_tier_id%TYPE,
    p_functionality_id     IN p_category_tier_functionality.functionality_id%TYPE
) AS
BEGIN
    DELETE FROM p_category_tier_functionality
     WHERE subscription_tier_id = p_subscription_tier_id
       AND functionality_id = p_functionality_id;

    IF SQL%rowcount = 0 THEN
        dbms_output.put_line('Nenhum relacionamento encontrado para remoção.');
    ELSE
        dbms_output.put_line('Relacionamento removido com sucesso.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Erro inesperado: ' || sqlerrm);
END;

-- ======================================================================

-- Teste

--INSERT
BEGIN
    sp_insert_category_tier_functionality(
        1,
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
BEGIN
    sp_insert_category_tier_functionality(
        1,
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
BEGIN
    sp_insert_category_tier_functionality(
        999,
        999
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
--DELETE
BEGIN
    sp_delete_category_tier_functionality(
        1,
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
BEGIN
    sp_delete_category_tier_functionality(
        999,
        999
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;

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
        'ACTIVE'
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
BEGIN
    sp_insert_subscription_status(
        'TESTE_Ativo',
        'DUPLICADO'
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
/
BEGIN
    sp_update_subscription_status(
        999999,
        'X',
        'Y'
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
--DELETE
DECLARE
    v_id p_subscription_status.subscription_status_id%TYPE;
BEGIN
    SELECT subscription_status_id
      INTO v_id
      FROM p_subscription_status
     WHERE description = 'TESTE_Cancelado';
    sp_delete_subscription_status(v_id);
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
BEGIN
    sp_delete_subscription_status(999999);
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/

-- Tabela Subscription
-- Insert

CREATE OR REPLACE PROCEDURE sp_insert_subscription (
    p_user_id                IN p_subscription.user_id%TYPE,
    p_subscription_tier_id   IN p_subscription.subscription_tier_id%TYPE,
    p_subscription_status_id IN p_subscription.subscription_status_id%TYPE,
    p_end_date               IN p_subscription.end_date%TYPE DEFAULT NULL
) AS
BEGIN
    INSERT INTO p_subscription (
        user_id,
        subscription_tier_id,
        subscription_status_id,
        end_date
    ) VALUES ( p_user_id,
               p_subscription_tier_id,
               p_subscription_status_id,
               p_end_date );

    dbms_output.put_line('Assinatura criada com sucesso.');
EXCEPTION
    WHEN dup_val_on_index THEN
        dbms_output.put_line('Erro: Assinatura duplicada.');
    WHEN OTHERS THEN
        dbms_output.put_line('Erro inesperado ao inserir assinatura: ' || sqlerrm);
END;


-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE sp_update_subscription (
    p_subscription_id        IN p_subscription.subscription_id%TYPE,
    p_subscription_tier_id   IN p_subscription.subscription_tier_id%TYPE,
    p_subscription_status_id IN p_subscription.subscription_status_id%TYPE,
    p_end_date               IN p_subscription.end_date%TYPE
) AS
BEGIN
    UPDATE p_subscription
       SET subscription_tier_id = p_subscription_tier_id,
           subscription_status_id = p_subscription_status_id,
           end_date = p_end_date,
           updated_at = systimestamp
     WHERE subscription_id = p_subscription_id;

    IF SQL%rowcount = 0 THEN
        dbms_output.put_line('Nenhuma assinatura encontrada para atualização.');
    ELSE
        dbms_output.put_line('Assinatura atualizada com sucesso.');
    END IF;
EXCEPTION
    WHEN dup_val_on_index THEN
        dbms_output.put_line('Erro: Conflito de chave única ao atualizar assinatura.');
    WHEN OTHERS THEN
        dbms_output.put_line('Erro inesperado ao atualizar assinatura: ' || sqlerrm);
END;


-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE sp_delete_subscription (
    p_subscription_id IN p_subscription.subscription_id%TYPE
) AS
BEGIN
    DELETE FROM p_subscription
     WHERE subscription_id = p_subscription_id;

    IF SQL%rowcount = 0 THEN
        dbms_output.put_line('Nenhuma assinatura encontrada para remoção.');
    ELSE
        dbms_output.put_line('Assinatura removida com sucesso.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Erro ao remover assinatura: ' || sqlerrm);
END;
/
-- ======================================================================

-- Teste

--INSERT
BEGIN
    sp_insert_subscription(
        1,
        1,
        1,
        DATE '2026-11-06'
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
BEGIN
    sp_insert_subscription(
        1,
        1,
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
BEGIN
    sp_insert_subscription(
        99999,
        1,
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
--UPDATE
DECLARE
    v_id p_subscription.subscription_id%TYPE;
BEGIN
    SELECT subscription_id
      INTO v_id
      FROM p_subscription
     WHERE user_id = 1;
    sp_update_subscription(
        v_id,
        1,
        1,
        DATE '2026-12-31'
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
BEGIN
    sp_update_subscription(
        999999,
        1,
        1
    );
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
--DELETE
DECLARE
    v_id p_subscription.subscription_id%TYPE;
BEGIN
    SELECT subscription_id
      INTO v_id
      FROM p_subscription
     WHERE user_id = 1;
    sp_delete_subscription(v_id);
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
BEGIN
    sp_delete_subscription(999999);
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/