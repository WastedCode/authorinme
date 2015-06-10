require 'rails_helper'

RSpec.describe Api::V1::AccountController, type: :controller do
    describe 'create' do
        let (:params) {{
            username: FactoryGirl.generate(:username),
            email: FactoryGirl.generate(:email),
            password: "abcdef",
            password_confirmation: "abcdef"
        }}

        context 'missing args' do
            it 'rejects missing username' do
                post :create, params.except(:username)
                expect_response_has_error(422, "username")
            end

            it 'rejects missing email' do
                post :create, params.except(:email)
                expect_response_has_error(422, "email")
            end

            it 'rejects missing password' do
                post :create, params.except(:password)
                expect_response_has_error(422, "password")
            end

            it 'rejects missing password_confirmation' do
                post :create, params.except(:password_confirmation)
                expect_response_has_error(422, "password_confirmation")
            end
        end

        it 'rejects short username' do
            post :create, params.merge(username: 'a')
            expect_response_has_error(422, "username")
        end

        it 'rejects long username' do
            post :create, params.merge(username: SecureRandom.hex(21))
            expect_response_has_error(422, "username")
        end

        it 'rejects duplicate username' do
            post :create, params
            expect(response.status).to eq(200)
            username = params[:username].upcase
            post :create, params.merge(username: " #{username} ")
            expect_response_has_error(422, "username")
        end

        it 'rejects duplicate email' do
            post :create, params
            expect(response.status).to eq(200)
            email = params[:email].upcase
            post :create, params.merge(email: " #{email} ")
            expect_response_has_error(422, "email")
        end

        it 'rejects mismatched password' do
            post :create, params.merge(password: "someotherpassword")
            expect_response_has_error(422, "password")
        end

        it 'creates an account' do
            expect {
                post :create, params
            }.to change{Account.count}.by(1)
            expect_response_to_have([:id], {username: params[:username], email: params[:email]})
        end
    end
end
