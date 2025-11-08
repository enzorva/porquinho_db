   SET SERVEROUTPUT ON;

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
END;
/
-- DELETE
BEGIN
    sp_delete_category_tier_functionality(
        1,
        1
    );
END;

SELECT *
  FROM p_category_tier_functionality;