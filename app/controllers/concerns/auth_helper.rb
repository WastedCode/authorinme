module AuthHelper
    extend ActiveSupport::Concern
    include ErrorHandler, SessionHelper

    def check_for_auth!
        if !current_account_id
            render_generic_error("Unauthorized", :unauthorized)
        end
    end
end
