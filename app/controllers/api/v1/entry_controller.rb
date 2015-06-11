class Api::V1::EntryController < ApplicationController
    include AuthHelper, ErrorHandler, ParamsHelper

    before_action :check_for_auth!, only: [:create]

    def create
        title = get_required_param_strip(:title)
        contents = get_required_param_strip(:contents)

        @entry = Entry.new(account: current_account, title: title, contents: contents)
        if !@entry.valid?
            render_generic_error(@entry.errors.full_messages, :unprocessable_entity)
            return
        end

        if !@entry.save
            render_generic_error("Unable to create entry", :internal_server_error)
            return
        end
    end
end
