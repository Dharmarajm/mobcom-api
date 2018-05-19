module Api
  module V1
    class ProjectsController < ApplicationController

      skip_before_action :check_session
      before_action :set_project, only: [:show, :update, :destroy]
      before_action :require_login!
      before_action :check_app_version
      skip_before_action :verify_authenticity_token

      respond_to :json

      def index
        result = []
        projects = Project.where(status: true)
        project_ids = TimeSheet.where(approval_status: nil).pluck(:project_id).uniq
        projects.map do |project|
          if project.project_employees.present?
            if project_ids.include?project.id
              result << project.as_json.merge({is_assigned: true, :approval_status => false})
            else
              result << project.as_json.merge({is_assigned: true, :approval_status => true})
            end
          else
            result << project.as_json.merge({is_assigned: false, :approval_status => true})
          end
        end
        render json: result
      end

      def show
        render json: @project
      end

      def create
        @project=Project.new(project_params)
        @project.save
        render json: @project
      end

      def update
        @project.update(project_params)
        render json: @project
      end

      def destroy
        @project.destroy
        render json: @project
      end

      def project_employee
        data=ProjectEmployee.where(:project_id=>params[:project_id])
        if data.present?
          employee=Employee.where(:id=>data.pluck(:employee_id))
          render json: employee
        else
          render json: []
        end 
      end  

      def require_login!
        return true if authenticate_token
        render json: { errors: [ { detail: "Access denied" } ] }, status: 401
      end

      def approval_status
        TimeSheet.where(:project_id=>params["project_id"]).update(:approval_status=>true)
        render json: true
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

      def set_project
        @project = Project.find(params[:id])
      end

      def project_params
        params.require(:project).permit(:name, :budget, :client_id)
      end

    end
  end
end