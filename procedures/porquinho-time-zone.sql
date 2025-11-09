-- Tabela Time Zone
-- Insert

CREATE OR REPLACE PROCEDURE pr_insert_time_zone (
    p_code        IN p_time_zone.code%TYPE,
    p_description IN p_time_zone.description%TYPE,
    p_utc_offset  IN p_time_zone.utc_offset%TYPE
) AS
BEGIN
    INSERT INTO p_time_zone (
        code,
        description,
        utc_offset
    ) VALUES ( p_code,
               p_description,
               p_utc_offset );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -20001,
            'Já existe um time zone com esse código ou descrição.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -20002,
            'Erro ao inserir time zone: ' || sqlerrm
        );
END;
/





-- ======================================================================

-- Update

CREATE OR REPLACE PROCEDURE pr_update_time_zone (
    p_time_zone_id IN p_time_zone.time_zone_id%TYPE,
    p_code         IN p_time_zone.code%TYPE,
    p_description  IN p_time_zone.description%TYPE,
    p_utc_offset   IN p_time_zone.utc_offset%TYPE
) AS
BEGIN
    UPDATE p_time_zone
       SET code = p_code,
           description = p_description,
           utc_offset = p_utc_offset
     WHERE time_zone_id = p_time_zone_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20003,
            'Nenhum time zone encontrado com o ID informado.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(
            -20004,
            'Já existe um time zone com esse código ou descrição.'
        );
    WHEN OTHERS THEN
        raise_application_error(
            -20005,
            'Erro ao atualizar time zone: ' || sqlerrm
        );
END;
/





-- ======================================================================

-- Delete

CREATE OR REPLACE PROCEDURE pr_delete_time_zone (
    p_time_zone_id IN p_time_zone.time_zone_id%TYPE
) AS
BEGIN
    DELETE FROM p_time_zone
     WHERE time_zone_id = p_time_zone_id;

    IF SQL%rowcount = 0 THEN
        raise_application_error(
            -20006,
            'Nenhum time zone encontrado com o ID informado.'
        );
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(
            -20007,
            'Erro ao remover time zone: ' || sqlerrm
        );
END;
/




-- ======================================================================

-- Teste

-- INSERT
BEGIN
    pr_insert_time_zone(
        'UTC-03:30',
        'Newfoundland',
        '-03:30'
    );
    COMMIT;
END;
/

-- UPDATE
DECLARE
    v_id p_time_zone.time_zone_id%TYPE;
BEGIN
    SELECT time_zone_id
      INTO v_id
      FROM p_time_zone
     WHERE code = 'UTC-03:00';
    pr_update_time_zone(
        v_id,
        'UTC-03:00',
        'Horário de Brasília (BRT)',
        '-03:00'
    );
END;
/

-- DELETE
DECLARE
    v_id p_time_zone.time_zone_id%TYPE;
BEGIN
    SELECT time_zone_id
      INTO v_id
      FROM p_time_zone
     WHERE code = 'UTC-03:30';
    pr_delete_time_zone(v_id);
END;
/


SELECT *
  FROM p_time_zone;