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


CREATE OR REPLACE FUNCTION fn_validate_transaction (
    p_account_id          IN NUMBER,
    p_value               IN NUMBER,
    p_transaction_icon_id IN NUMBER,
    p_color_id            IN NUMBER
) RETURN VARCHAR2 IS
    v_exists  NUMBER;
    v_balance NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO v_exists
      FROM p_account
     WHERE account_id = p_account_id;
    IF v_exists = 0 THEN
        RETURN 'Conta não existe';
    END IF;
    IF p_value <= 0 THEN
        RETURN 'O valor da transação deve ser positivo';
    END IF;
    SELECT COUNT(*)
      INTO v_exists
      FROM p_transaction_icon
     WHERE transaction_icon_id = p_transaction_icon_id;
    IF v_exists = 0 THEN
        RETURN 'Ícone de transação não existe';
    END IF;
    SELECT COUNT(*)
      INTO v_exists
      FROM p_color
     WHERE color_id = p_color_id;
    IF v_exists = 0 THEN
        RETURN 'Cor não existe';
    END IF;
    SELECT balance
      INTO v_balance
      FROM p_account
     WHERE account_id = p_account_id;
    IF v_balance < p_value THEN
        RETURN 'Saldo insuficiente para a transação';
    END IF;
    RETURN 'VÁLIDO';
END;

SELECT fn_validate_transaction(
    1,
    50,
    1,
    1
) AS resultado
  FROM dual;

SELECT fn_validate_transaction(
    1,
    0,     -- valor inválido
    1,
    1
) AS resultado
  FROM dual;