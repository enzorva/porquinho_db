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
END;

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
END;

--DELETE

DECLARE
    v_id p_user.user_id%TYPE;
BEGIN
    SELECT user_id
      INTO v_id
      FROM p_user
     WHERE email = 'TESTE_maria.souza@teste.com';
    pr_delete_user(v_id);
END;
/