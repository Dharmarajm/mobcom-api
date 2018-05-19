module Api
  module V1
    class EmployeesController < ApplicationController

      skip_before_action :check_session
      before_action :set_employee, only: [:show, :update, :destroy]
      before_action :require_login! ,:except=>[:employee_details]
      before_action :check_app_version
      skip_before_action :verify_authenticity_token

      respond_to :json

      def index
        #@employees = Employee.all
        aa = TimeSheet.where(approval_status: nil).pluck(:employee_id).uniq
        employees = Employee.all.map do |emp|
          if aa.include?emp.id
            emp.as_json.merge({:approval_status => false})
          else
            emp.as_json.merge({:approval_status => true})
          end
        end
        render json: employees
      end

      def show
        render json: @employee
      end

      def create
        @employee=Employee.new(employee_params)
        @employee.save
        render json: @employee
      end

      def update
        @employee.update(employee_params)
        render json: @employee
      end

      def destroy
        @employee.destroy
        render json: @employee
      end

      def employee_details
        employee=Employee.where(:email=>params[:email])
        if employee.present?
          employee1=Employee.where(:email=>params[:email],:status=>nil)
          if employee1.present?
            render json: employee1
          else
            render json: true #{"message"=>"already registered"} 
          end   
        else  
         render json: false#{"message"=>"Sorry this email is not registered"} 
        end
      end  

      def project_assign
        params.permit!
        #employee_id=User.find(params[:user_id]).employee_id
        project=ProjectEmployee.create(:project_id=>params[:project_id],:employee_id=>params[:employee_id])
        unless project["id"].nil?
          render json: true
        else
          render json: false
        end
      end  

      def unassigned_project
        employee = ProjectEmployee.where(:employee_id=>params["employee_id"])
        if employee.present?
          project = Project.where.not(:id=>employee.pluck(:project_id))
          render json: project
        else
          render json: Project.all
        end
      end  

      def assigned_project 
        employee=ProjectEmployee.where(:employee_id=>params["employee_id"])
        if employee.present?
          project=Project.where(:id=>ProjectEmployee.where(:employee_id=>params["employee_id"]).pluck(:project_id))
          render json: project
        else
          render json: false#Project.all
        end 
      end

      def image_upload
        ten=Time.now.strftime("%d-%m-%Y %H:%M:%S").to_s
        path = "public/#{ten}.png"
        img_binary = params[:message_log][:image].split(",")[1]
        File.open(path,"wb"){|pp| pp.write Base64.decode64(img_binary) }
        path=File.open(File.join(Rails.root,path))
        Employee.find(params[:message_log][:employee_id]).update(:image=>path) 
        render json: true
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

      def set_employee
        @employee = Employee.find(params[:id])
      end

      def employee_params
        params.require(:employee).permit(:first_name, :last_name, :mobile_number, :email, :employee_id, :designation, :date_of_birth, :street, :pincode, :city, :state, :country, :status)
      end

    end
  end
end