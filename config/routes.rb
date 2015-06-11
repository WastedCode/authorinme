Rails.application.routes.draw do
    namespace :api, constraints: { format: 'json' } do
        namespace :v1 do
            # Account
            post 'account/create'

            # Session
            post 'account/login'
            delete 'account/logout'

            # Entries
            post 'entry/create'
        end
    end
end
