require('./lib/errors/missing_required_param_error.rb')

module ParamsHelper
    extend ActiveSupport::Concern

    def get_required_param(param_name)
        raise Errors::MissingRequiredParamError, "Missing param: #{param_name}" unless params.include?(param_name.to_sym)
        params[param_name]
    end

    def get_required_param_strip_and_downcase(param_name)
        get_required_param_strip(param_name).downcase
    end

    def get_required_param_strip(param_name)
        if params.include?(param_name)
            value = params[param_name].strip
            return value unless value.empty?
        end
        raise Errors::MissingRequiredParamError, "Missing param: #{param_name}"
    end
end
