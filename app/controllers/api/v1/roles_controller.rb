module Api
  module V1
    class RolesController < ApplicationController

      skip_before_action :check_session     
      before_action :set_Role, only: [:show, :update, :destroy]
      before_action :require_login!
      before_action :check_app_version
      skip_before_action :verify_authenticity_token
      respond_to :json

      def index
        @roles = Role.all
        render json: @roles
      end

      def show
        render json: @role
      end

      def create
        @role=Role.new(role_params)
        @role.save
        render json: @role
      end

      def update
        @role.update(role_params)
        render json: @role
      end

      def destroy
        @role.destroy
        render json: @role
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

      def set_role
        @role = Role.find(params[:id])
      end

      def role_params
        params.require(:role).permit(:name)
      end
    end
  end 
end