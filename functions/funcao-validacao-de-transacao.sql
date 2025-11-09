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