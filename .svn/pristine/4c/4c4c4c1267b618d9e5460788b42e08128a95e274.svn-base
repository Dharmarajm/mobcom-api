module Api
  module V1
    class LogsController < ApplicationController

      skip_before_action :check_session
      before_action :set_Role, only: [:show, :update, :destroy]
      before_action :require_login!
      before_action :check_app_version
      skip_before_action :verify_authenticity_token
   
      respond_to :json

      def call_index
        @call_logs = CallLog.all
        render json: @call_logs
      end

      def call_show
      	@call_log = CallLog.find(params[:call_log_id])
        render json:@call_log 
      end

      def call_create
        @call=CallLog.new(call_log_params)
        @call.save
        render json: @call
      end

      def call_update
      	@call_log = CallLog.find(params[:call_log_id])
        @call_log.update(call_log_params)
        render json: @call_log
      end

     def message_index
        @messages = MessageLog.all
        render json: @messages
      end

      def message_show
      	@message_log = MessageLog.find(params[:message_log_id])
        render json: @message_log
      end

      def message_create
        @message=MessageLog.new(message_log_params)
        @message.save
        render json: @message
      end

      def message_update
      	message_log = MessageLog.find(params[:call_log_id])
        @message_log.update(message_log_params)
        render json: @message_log
      end


      def require_login!
        return true if authenticate_token
        render json: { errors: [ { detail: "Access denied" } ] }, status: 401
      end

      private

      def check_app_version
        return true if params[:app_version].present? and AppVersion.last.version_no == params[:app_version]
        render json: { errors: [ { detail: "Access denied !! Check App Version" } ] }, status: 401
      end  

      def authenticate_token
        authenticate_with_http_token do |token, options|
          User.find_by(auth_token: token)
        end
      end
      
      def call_log_params
        params.require(:call_log).permit(:from_employee_id, :to_employee_id, :to_contact_id, :start_time, :end_time)
      end

      def message_log_params
        params.require(:message_log).permit(:from_employee_id, :to_employee_id, :to_contact_id, :message)
      end

    end
  end
end