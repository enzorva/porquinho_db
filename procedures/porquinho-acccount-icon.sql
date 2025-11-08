   SET SERVEROUTPUT ON;

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
            -20010,
            'Já existe um ícone com esse nome, label ou URL.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -20011,
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
            -20012,
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
            -20013,
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
            -20015,
            'Ícone não encontrado para remoção.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20016,
            'Erro ao remover ícone: ' || sqlerrm
        );
END;
/

-- ======================================================================

-- Teste

-- INSERT
BEGIN
    pr_insert_account_icon(
        p_name  => 'test_icon',
        p_label => 'Test Icon Label',
        p_url   => 'http://example.com/test.png'
    );
END;
/

-- UPDATE
BEGIN
    pr_update_account_icon(
        p_account_icon_id => 11,
        p_name            => 'updated_icon',
        p_label           => 'Updated Icon Label',
        p_url             => 'http://example.com/updated.png'
    );
END;
/

-- DELETE
BEGIN
    pr_delete_account_icon(11);
END;
/

SELECT *
  FROM p_account_icon;