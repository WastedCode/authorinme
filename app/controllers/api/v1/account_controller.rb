class Api::V1::AccountController < ApplicationController
    include AccountHelper, ParamsHelper, SessionHelper

    def create
        data = {}
        data[:username] = get_required_param_strip_and_downcase(:username)
        data[:email] = get_required_param_strip_and_downcase(:email)
        data[:password] = get_required_param_strip(:password)
        data[:password_confirmation] = get_required_param_strip(:password_confirmation)

        begin
            @account = create_account(data)
            add_login_cookie(@account.id)
        rescue Errors::InvalidAccountError => e
            render_generic_error e.message, :unprocessable_entity
        end
    end

    def login
        username = get_required_param_strip_and_downcase(:username)
        password = get_required_param_strip(:password)

        begin
            @account = Account.for_username(username, password)
            add_login_cookie(@account.id)
        rescue Errors::InvalidUsernameError, Errors::IncorrectPasswordError => e
            render_generic_error e.message, :unauthorized
        end
    end
end
