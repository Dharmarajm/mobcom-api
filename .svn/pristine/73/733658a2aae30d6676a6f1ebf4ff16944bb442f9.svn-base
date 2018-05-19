class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @employees = Employee.all
    
  end

  def show
    respond_with(@employee)
  end

  def new
    @employee = Employee.new
    respond_with(@employee)
  end

  def edit
  end

  def create
    @employee = Employee.new(employee_params)
    @employee.save
    redirect_to employees_path
    #respond_with(@employee)
    flash[:notice]="Employee Successfully Created"
  end

  def update
    @employee.update(employee_params)
    redirect_to employees_path
    #respond_with(@employee)
    flash[:notice]="Employee Successfully Updated"
    #redirect_to :action=>"index"
    

  end

  def destroy
    @employee.destroy
    respond_with(@employee)
    flash[:notice]="Employee Successfully Deleted"
  end

  def import_employee
  params.permit!
  data=Employee.import_data(params)
  flash[:message]="#{data}"
  redirect_to :action=>"index"
  end  

  def employee_report
    #byebug
    @employees = Employee.all
    @projects = Project.all
    if params["commit"] == "Get Report"
      @working_days = params["working_days"]
      @employee_reports = Employee.employee_report(params)
    else
      @working_days = 7
      from_date = 1.week.ago.strftime("%Y-%m-%d")
      to_date = Date.today.strftime("%Y-%m-%d")
      @employee_reports = Employee.employee_report("employee_id": nil, "from_date": from_date, "to_date": to_date)
    end
  end


  private
    def set_employee
      @employee = Employee.find(params[:id])
    end

    def employee_params
      params.require(:employee).permit(:first_name, :last_name, :mobile_number, :email, :employee_id, :designation, :ctc, :date_of_birth, :street, :pincode, :city, :state, :country, :status)
    end
end
