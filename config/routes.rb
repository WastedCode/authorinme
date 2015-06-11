Rails.application.routes.draw do
    namespace :api, constraints: { format: 'json' } do
        namespace :v1 do
            post 'account/create'
            post 'account/login'
            delete 'account/logout'
        end
    end
end
