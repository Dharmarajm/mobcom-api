module Api
  module V1
    class ContactsController < ApplicationController
      skip_before_action :check_session
      before_action :set_contact, only: [:show, :update, :destroy]
      before_action :require_login!
      before_action :check_app_version
      skip_before_action :verify_authenticity_token

      respond_to :json

      def index
        @contacts = Contact.all
        render json: @contacts
      end

      def show
        render json: @contact
      end

      def create
        @contact=Contact.new(contact_params)
        @contact.save
        render json: @contact
      end

      def update
        @contact.update(contact_params)
        render json: @contact
      end

      def destroy
        @contact.destroy
        render json: @contact
      end

      def client_contacts
       contacts=Contact.where(:client_id=>params[:client_id])
       render json: contacts
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
    
      def set_contact
        @contact = contact.find(params[:id])
      end

      def contact_params
        params.require(:contact).permit(:name, :email, :mobile_number, :telephone_number, :client_id, :designation)
      end

    end
  end
end