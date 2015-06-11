module ErrorHandler
    include ActiveSupport::Concern

    def handle_missing_required_param(error)
        render_generic_error(error.message, :unprocessable_entity)
    end

    def render_generic_error(message, status)
        render json: {error_message: message}, status: status
    end

    def render_success
        render json: {success: true}, status: :ok
    end
end
