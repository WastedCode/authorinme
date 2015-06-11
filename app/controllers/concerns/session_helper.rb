module SessionHelper
    extend ActiveSupport::Concern

    protected

    def current_account
        return nil unless current_account_id
        @current_account ||= Account.where(id: current_account_id).first
    end

    def current_account_id
        @current_account_id ||= cookies.permanent.signed[:aid]
    end

    def add_login_cookie(id)
        cookies.permanent.signed[:aid] = id
    end

    def remove_login_cookie
        cookies.delete(:aid)
    end
end
