module Api
  module V1
    class UsersController < ApplicationController

      skip_before_action :check_session
      before_action :set_user, only: [:show, :update, :destroy]
      before_action :require_login!,:except => [ :login_validation, :user_registration, :forgot_password]
      before_action :check_app_version
      skip_before_action :verify_authenticity_token      

      respond_to :json

      def index
        @users = User.all
        render json: @users
      end

      def show
        render json: @user
      end

      def create
        @user=User.new(user_params)
        auth_token = User.generate_auth_token
        @user["auth_token"] = auth_token
        @user.save
        render json: @user
      end

      def update
        @user.update(user_params)
        render json: @user
      end

      def destroy
        @user.destroy
        render json: @user
      end

      def login_validation
        user = User.find_by(email: params["email"])
        if user && user.authenticate(params["password"])
          #auth_token = User.generate_auth_token
          #User.find(user["id"]).update(:auth_token=>auth_token)
          user=User.find(user["id"]).as_json(include: [:role,:employee])
          render json: user
        else
          render json: false
        end
      end

      def user_registration
        params.permit!
        user = User.create(:email => params[:email], :password => params[:password], :role_id => Role.where(:name => "Employee").ids[0], :employee_id => params[:id], :auth_token => User.generate_auth_token)
        Employee.find(params[:id]).update(:status=>1, :ctc=>params[:ctc])
        render json: user
      end

      def require_login!
        return true if authenticate_token
        render json: { errors: [ { detail: "Access denied" } ] }, status: 401
      end
       
      def forgot_password
        if User.find_by_email(params["email"]).present?
          #user=User.find_by_email(params["email"]).update(:password=>params["password"],:password_confirmation=>params["password"])
          @user=User.find_by_email(params["email"])
          ReportMailer.sendmail(@user).deliver
          render json: {"message"=>"Please check registered mail"}
        else  
          render json: {"message"=>"Email is invalid"}
        end
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

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:email, :password, :role_id, :employee_id)
      end
      
    end

  end
end