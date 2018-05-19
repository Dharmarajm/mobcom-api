  module Api  
  module V1    
    class TimeSheetsController < ApplicationController

      skip_before_action :check_session
      before_action :set_time_sheet, only: [:show, :update, :destroy]
      #before_action :require_login!
      before_action :check_app_version
      skip_before_action :verify_authenticity_token

      respond_to :json

      def index
        @time_sheets = TimeSheet.all.as_json(include: [:project,:employee])
        render json: @time_sheets
      end

      def show
        render json: @time_sheet
      end

      def create
        params.permit!
        time_sheets = []
        params[:data].map do |time_sheet|

          timesheets = TimeSheet.where(:date => time_sheet[:date], :employee_id => time_sheet[:employee_id])

          if time_sheet[:project_id].present?

            if timesheets.find_by(:project_id => time_sheet[:project_id], :approval_status => true).present?

              time_sheets << timesheets.find_by(:project_id => time_sheet[:project_id], :approval_status => true)

            elsif timesheets.find_by(:project_id => time_sheet[:project_id], :approval_status => nil).present?

              if time_sheet[:hours].to_i == 0
                
                ts = timesheets.map { |e| e.destroy }

                ts = TimeSheet.create(:date => time_sheet[:date], :employee_id => time_sheet[:employee_id], :attendance_log => false, :hours => 0, :approval_status => true)

                time_sheets << ts

              else

                ts = timesheets.find_by(:project_id => time_sheet[:project_id], :approval_status => nil)

                ts.update(:hours => time_sheet[:hours], :attendance_log => time_sheet[:attendance_log])

                time_sheets << ts
              end

            else

              time_sheets << TimeSheet.create(:date => time_sheet[:date], :project_id => time_sheet[:project_id], :employee_id => time_sheet[:employee_id], :attendance_log => time_sheet[:attendance_log], :hours => time_sheet[:hours])

            end

          else

            timesheets.map { |e| e.destroy }

            time_sheets << TimeSheet.create(:date => time_sheet[:date], :employee_id => time_sheet[:employee_id], :attendance_log => false, :hours => 0)

          end
        end
        render json: time_sheets.flatten
      end

      def update
        @time_sheet.update(time_sheet_params)
        render json: @time_sheet
      end

      def destroy
        @time_sheet.destroy
        render json: @time_sheet
      end

      def date
        start_date=Date.today.beginning_of_week-1.week-1
        end_date=Date.today.end_of_week+1.week-1
        render json: {:start_date=>start_date,:end_date=>end_date}
      end  

      def time_sheet_details
        time_sheet=TimeSheet.where(:email=>params[:email])
        render json: time_sheet
      end  

      def employee_time_sheet
        employee_id = params[:employee_id]
        case params["date"]
          when "previous"
            @dates = (Date.today.beginning_of_week-(params[:period].to_i.week)-1..Date.today.end_of_week-(params[:period].to_i).week-1)
          when "current"
            @dates = (Date.today.beginning_of_week-1..Date.today.end_of_week-1)
        end

        if @dates.present?
          over_all = []
          time_sheets = TimeSheet.where(date: @dates, employee_id: employee_id)
          projects = time_sheets.pluck(:project_id).uniq
          over_all_approval_status = time_sheets.pluck(:approval_status).uniq.include?(nil) ? true : false
          date_range = [{"date_range" => @dates, "over_all_approval_status" => over_all_approval_status }]
          projects.each do |project|
            data = []
            data = @dates.map do |dat|
              if time_sheets.where(:project_id => project, date: dat).present?
                ids_hour = time_sheets.where(:project_id => project, date: dat).pluck(:id, :hours, :approval_status, :attendance_log)
                {
                  :time_sheet_id => ids_hour[0][0],
                  :date => dat,
                  :day => dat.strftime('%a'),
                  :hours => ids_hour[0][1],
                  :approval_status => (ids_hour[0][2] == nil ? false : ids_hour[0][2]),
                  :attendance_log => ids_hour[0][3]
                }
              else
                {
                  :time_sheet_id => nil,
                  :date => dat,
                  :day => dat.strftime('%a'),
                  :hours => 0,
                  :approval_status => nil,
                  :attendance_log => nil
                }
              end
            end
            if project.present?
              over_all << {"project_id" => project, "project_name" => Project.find(project).name, "data" => data}
            else
              over_all << {"project_id" => "No Project", "project_name" => "No Project", "data" => data}
            end            
          end
          result = date_range << over_all
        else
          result = false  
        end
        render json: result 
      end

      def project_working_hours
        project_id = params["project_id"]
        case params["date"]
          when "previous"
            @dates = (Date.today.beginning_of_week-(params[:period].to_i.week)-1..Date.today.end_of_week-(params[:period].to_i).week-1)
          when "current"
            @dates = (Date.today.beginning_of_week-1..Date.today.end_of_week-1)
        end

        if @dates.present?
          over_all = []
          time_sheets = TimeSheet.where(date: @dates, project_id: project_id)
          employees = time_sheets.pluck(:employee_id).uniq.compact
          over_all_approval_status = time_sheets.pluck(:approval_status).uniq.include?(nil) ? true : false
          date_range = [{"date_range" => @dates, "over_all_approval_status" => over_all_approval_status }]
          employees.each do |employee|
            data = []
            data = @dates.map do |dat|
              if time_sheets.where(:employee_id => employee, date: dat).present?
                ids_hour = time_sheets.where(:employee_id => employee, date: dat).pluck(:id, :hours, :approval_status, :attendance_log)
                {
                  :time_sheet_id => ids_hour[0][0],
                  :date => dat,
                  :day => dat.strftime('%a'),
                  :hours => ids_hour[0][1],
                  :approval_status => (ids_hour[0][2] == nil ? false : ids_hour[0][2]),
                  :attendance_log => ids_hour[0][3]
                }
              else
                {
                  :time_sheet_id => nil,
                  :date => dat,
                  :day => dat.strftime('%a'),
                  :hours => 0,
                  :approval_status => nil,
                  :attendance_log => nil
                }
              end
            end
            over_all << {"employee_id" => employee, "employee_name" => Employee.find(employee).first_name, "data" => data}
          end
          result = date_range << over_all
        else
          result = false  
        end
        render json: result 
      end

      def time_approval_status
        params.permit!
        case params["date"]
          when "previous"
            @dates = (Date.today.beginning_of_week-(params[:period].to_i.week)-1..Date.today.end_of_week-(params[:period].to_i).week-1)
          when "current"
            @dates = (Date.today.beginning_of_week-1..Date.today.end_of_week-1)
        end
        TimeSheet.where(date: @dates, employee_id: params["employee_id"]).update(:approval_status=>true)
        render json: true
      end  

      def cost_estimate
        @data=[]
        employee=TimeSheet.where(:project_id=>params[:project_id]).group_by(&:employee_id)
        if employee.present?
          employee.map{|i|  emp=Employee.find(i[0]); @data << {"name"=>emp.first_name,"ctc"=>emp.ctc,"hours"=>i[1].pluck(:hours).sum,"amount"=>emp.ctc.nil? ? "not assigned ctc" : (i[1].pluck(:hours).sum)*(emp.ctc)}}
        end 
        render json: @data
      end 

      def is_absent
        if TimeSheet.where(date: params[:date], employee_id: params[:employee_id]).present?
          attendance_log = TimeSheet.where(date: params[:date], employee_id: params[:employee_id]).pluck(:attendance_log).uniq
          if attendance_log.count == 1 and attendance_log[0] == true
            result = {"attendance_log" => "Present"}
          elsif attendance_log.count == 1 and attendance_log[0] == false
            result = {"attendance_log" => "Absent"}
          else
            result = {"attendance_log" => "Data Incorrect"}
          end
        else
          result = {"attendance_log" => "No data found"}
        end
        render json: result
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

      def set_time_sheet
        @time_sheet = TimeSheet.find(params[:id])
      end

      def time_sheet_params
        params.require(:time_sheet).permit(:date, :hours, :project_id, :employee_id, :approval_status, :revised_hours, :attendance_log)
      end
      
    end
  end
end
