module SessionHelper
    extend ActiveSupport::Concern

    protected

    def add_login_cookie(id)
        cookies.permanent.signed[:aid] = id
    end

    def remove_login_cookie
        cookies.delete(:aid)
    end
end
