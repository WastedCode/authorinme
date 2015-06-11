require 'rails_helper'

RSpec.describe Api::V1::AccountController, type: :controller do
    render_views

    describe 'logout' do
        it 'clears the cookies' do
            account = FactoryGirl.create(:account)
            post :login, {username: account.username, password: account.password, format: :json}
            expect(cookies.count).to_not eq(0)
            delete :logout
            expect(cookies.permanent.signed['aid']).to be_nil
        end
    end

    describe 'login' do
        let (:password) { 'password' }
        let (:account) { FactoryGirl.create(:account, password: password, password_confirmation: password) }
        let (:params) {{
            format: :json,
            username: account.username,
            password: password
        }}

        context 'missing args' do
            it 'rejects missing username' do
                post :login, params.except(:username)
                expect_response_has_error(422, "username")
            end

            it 'rejects missing password' do
                post :login, params.except(:password)
                expect_response_has_error(422, "password")
            end
        end

        it 'rejects invalid username' do
            post :login, params.merge(username: FactoryGirl.generate(:username))
            expect_response_has_error(401, "username")
        end

        it 'rejects wrong password' do
            post :login, params.merge(password: "blaaah")
            expect_response_has_error(401, "password")
        end

        it 'returns the account on success' do
            post :login, params
            expect_response_to_have([:id], {username: account.username, email: account.email})

            account = JSON.parse(response.body)
            expect(cookies.signed.permanent['aid']).to eq(account["id"])
        end
    end

    describe 'create' do
        let (:params) {{
            format: :json,
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

            account = JSON.parse(response.body)
            expect(cookies.signed.permanent['aid']).to eq(account["id"])
        end
    end
end
