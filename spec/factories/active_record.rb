FactoryGirl.define do
    factory :account do
        username { generate(:username) }
        email { generate(:email) }
        password { 'abcdef' }
        password_confirmation { 'abcdef' }
    end

    factory :entry do
        account
        title { SecureRandom.hex }
        contents { SecureRandom.hex }
    end
end
