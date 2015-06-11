require 'rails_helper'

RSpec.describe Api::V1::EntryController, type: :controller do
    render_views

    describe 'create' do
        context 'for a valid user' do
            let(:account) { FactoryGirl.create(:account) }
            let(:params) {{
                format: :json,
                title: SecureRandom.hex,
                contents: SecureRandom.hex
            }}

            before {cookies.signed.permanent[:aid] = account.id}

            it 'rejects missing title' do
                post :create, params.except(:title)
                expect_response_has_error(422, "title")
            end

            it 'rejects missing content' do
                post :create, params.except(:contents)
                expect_response_has_error(422, "contents")
            end

            it 'creates the entry' do
                post :create, params
                expect(response.status).to eq(200)
                expect_response_to_have([:id], {title: params[:title], contents: params[:contents]})
            end
        end

        it 'rejects unauthenticated request' do
            post :create, format: :json
            expect(response.status).to eq(401)
        end
    end
end
