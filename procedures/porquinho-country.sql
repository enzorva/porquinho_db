   SET SERVEROUTPUT ON;

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
            -20001,
            'Já existe um país com esse nome ou sigla.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -20002,
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
            -20003,
            'Nenhum país encontrado com o ID informado.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -20004,
            'Já existe um país com esse nome ou sigla.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -20005,
            'Erro ao atualizar país: ' || sqlerrm
        );
END;
/


-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_country (
    p_country_id IN p_country.country_id%TYPE
) AS
BEGIN
    DELETE FROM p_country
     WHERE country_id = p_country_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20006,
            'Nenhum país encontrado com o ID informado.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20007,
            'Erro ao deletar país: ' || sqlerrm
        );
END;
/

-- ======================================================================

-- Teste

--INSERT
BEGIN
    pr_insert_country(
        'TESTE_Brasil',
        'TE'
    );
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
        'AA'
    );
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
END;


SELECT *
  FROM p_country;