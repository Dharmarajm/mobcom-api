class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @projects = Project.all
    respond_with(@projects)
  end

  def show
    respond_with(@project)
  end

  def new
    @project = Project.new
    respond_with(@project)
  end

  def edit
  end

  def create
    @project = Project.new(project_params)
    @project.save
    redirect_to projects_path
    #respond_with(@project)
  end

  def update
    @project.update(project_params)
    redirect_to projects_path
    #respond_with(@project)
  end

  def destroy
    @project.destroy
    respond_with(@project)
  end

  def project_active_status
    params.permit!
    Project.find(params["id"]).update(status: params["status"])
    redirect_to projects_path
    #Project.find(params["id"]).update(status: params["status"])
  end  

  def project_report
    @projects = Project.all
    if params["commit"] == "Get Report"
      @from_date = params["from_date"]
      @to_date = params["to_date"]
      @project_reports = Project.project_report(params)
    else
      @from_date = 1.week.ago.strftime("%Y-%m-%d")
      @to_date = Date.today.strftime("%Y-%m-%d")
      @project_reports = Project.project_report("project" => {"id" => ""}, "from_date": @from_date, "to_date": @to_date)
    end
  end

  def detailed_report
    project = Project.find_by(:name => params[:name])
    time_sheet = TimeSheet.where(:project_id => project.id)
    employee_time_sheets = time_sheet.group_by(&:employee_id)
    @employee_details = employee_time_sheets.map do |k, v|
      employee = Employee.find(k)
      ctc = employee.ctc
      one_hour = (ctc/24)/8
      time = v.pluck(:hours).compact.sum
      {
        :employee_name => employee.first_name,
        :hours => v.pluck(:hours).compact.sum,
        :cost => (time*one_hour)
      }
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :budget, :client_id)
  end

end
