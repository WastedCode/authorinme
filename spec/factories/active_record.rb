FactoryGirl.define do
    factory :account do
        username { generate(:username) }
        email { generate(:email) }
        password { 'abcdef' }
        password_confirmation { 'abcdef' }
    end
end
