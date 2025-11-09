CREATE OR REPLACE FUNCTION fn_validate_user_data (
    p_email                IN VARCHAR2,
    p_country_id           IN NUMBER,
    p_time_zone_id         IN NUMBER,
    p_finance_objective_id IN NUMBER,
    p_gender               IN VARCHAR2
) RETURN VARCHAR2 IS
    v_exists NUMBER;
BEGIN
    IF NOT regexp_like(
        p_email,
        '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
    ) THEN
        RETURN 'Formato de email invalido';
    END IF;
    SELECT COUNT(*)
      INTO v_exists
      FROM p_country
     WHERE country_id = p_country_id;
    IF v_exists = 0 THEN
        RETURN 'País não existe';
    END IF;
    SELECT COUNT(*)
      INTO v_exists
      FROM p_time_zone
     WHERE time_zone_id = p_time_zone_id;
    IF v_exists = 0 THEN
        RETURN 'Fuso horário não existe';
    END IF;
    IF p_finance_objective_id IS NOT NULL THEN
        SELECT COUNT(*)
          INTO v_exists
          FROM p_finance_objective
         WHERE finance_objective_id = p_finance_objective_id;
        IF v_exists = 0 THEN
            RETURN 'Objetivo financeiro não existe';
        END IF;
    END IF;

    IF p_gender NOT IN ( 'masculine',
                         'feminine',
                         'other' ) THEN
        RETURN 'Gênero invalido';
    END IF;
    RETURN 'VÁLIDO';
END;

SELECT fn_validate_user_data(
    'teste@example.com', -- p_email
    1,                   -- p_country_id
    3,                   -- p_time_zone_id
    2,                   -- p_finance_objective_id
    'masculine'          -- p_gender
) AS resultado
  FROM dual;

SELECT fn_validate_user_data(
    'teste@example.com',
    1,
    3,
    2,
    'banana'
) AS resultado
  FROM dual;