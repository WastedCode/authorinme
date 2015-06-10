require('./lib/errors/missing_required_param_error.rb')

class ApplicationController < ActionController::Base
    include ErrorHandler

    rescue_from Errors::MissingRequiredParamError, with: :handle_missing_required_param
end
