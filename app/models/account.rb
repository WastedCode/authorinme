require('./lib/errors/incorrect_password_error')
require('./lib/errors/invalid_username_error')

class Account < ActiveRecord::Base
    has_secure_password
    validates :username, presence: true, uniqueness: true, length: {minimum: 2, maximum: 40}
    validates :email, presence: true, uniqueness: true, length: {minimum: 5, maximum: 100}
    validates :password, length: {minimum: 6, maximum: 72}

    def self.for_username(username, password)
        account = Account.where(username: username).try(:first)
        raise InvalidUsernameError, "The username: #{username} was not found" unless account
        raise IncorrectPasswordError, "The password for username: #{username} does not match" unless account.authenticate(password)

        account
    end
end
