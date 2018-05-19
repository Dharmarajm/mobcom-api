module Api
  module V1

    class ClientsController < ApplicationController
      skip_before_action :check_session
      before_action :set_Client, only: [:show, :update, :destroy]
      before_action :require_login!  
      before_action :check_app_version
      skip_before_action :verify_authenticity_token
      
      respond_to :json

      def index
        @clients = Client.all
        render json: @clients
      end

      def show
        render json: @client
      end

      def create
        @client=Client.new(Client_params)
        @client.save
        render json: @client
      end

      def update
        @client.update(client_params)
        render json: @client
      end

      def destroy
        @client.destroy
        render json: @client
      end

      def client_projects
        client=Client.all.as_json(include: :projects)
        render json: client
      end
      
      def client_contacts
        client=Client.find(params[:client_id]).contacts
        render json: client
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
      
      def set_Client
        @client = Client.find(params[:id])
      end

      def Client_params
        params.require(:client).permit(:name, :street, :pincode, :city, :state, :country)
      end
    end

  end
end