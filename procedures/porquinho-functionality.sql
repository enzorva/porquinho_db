   SET SERVEROUTPUT ON;

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
END;
--DELETE
DECLARE
    v_id p_functionality.functionality_id%TYPE;
BEGIN
    SELECT functionality_id
      INTO v_id
      FROM p_functionality
     WHERE name = 'TESTE_Orçamento';
    sp_delete_functionality(v_id);
END;

SELECT *
  FROM p_functionality;