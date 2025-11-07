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