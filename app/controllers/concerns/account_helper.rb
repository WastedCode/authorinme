require('./lib/errors/invalid_account_error')

module AccountHelper
    extend ActiveSupport::Concern

    def create_account(data)
        account = Account.new
        account.username = data[:username]
        account.email = data[:email]
        account.password = data[:password]
        account.password_confirmation = data[:password_confirmation]

        if (account.valid? && account.save)
            return account
        end

        raise Errors::InvalidAccountError, account.errors.full_messages
    end
end
