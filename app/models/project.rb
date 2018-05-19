class Project < ApplicationRecord
  belongs_to :client
  has_many :project_employees, dependent: :destroy
  has_many :time_sheets, dependent: :destroy
  validates_uniqueness_of :name

  def self.get_data(report)
    report_type = report
    if report_type == "weekly"
      @dates = (Date.yesterday.beginning_of_week-1..Date.yesterday.end_of_week-1)
    elsif report_type == "monthly"
      @dates = ((Date.yesterday-1).beginning_of_month..(Date.yesterday-1).end_of_month)
    end
    if Project.where(:status => true).present?
      tot_data1, tot_data2, tot_data3, tot_data4 = [], [], [], []
      @project_over_all_data = []
      Project.where(:status => true).map do |project|
        over_all_project_hours = []    
        over_all_project_cost = []
        project_hours = []
        project_cost = []
        if TimeSheet.where(:approval_status => true, :project_id => project["id"]).present?
          employee_group = TimeSheet.where(:approval_status => true, :project_id => project["id"]).group_by(&:employee_id)
          employee_group.map do |employee_id,time_sheet|
            ctc = Employee.find(employee_id).ctc
            time = time_sheet.pluck(:hours).sum
            one_hour = (ctc/24)/8
            over_all_project_hours << time
            over_all_project_cost << (time*one_hour)
          end
          time_sheets = TimeSheet.where(:date => @dates, :approval_status => true, :project_id => project["id"])
          if time_sheets.present?
           employee_group = time_sheets.group_by(&:employee_id)
            employee_group.map do |employee_id,time_sheet|
              ctc = Employee.find(employee_id).ctc
              time = time_sheet.pluck(:hours).sum
              one_hour = (ctc/24)/8
              project_hours << time
              project_cost << (time*one_hour)
            end 
          else
            project_hours << nil
            project_cost << nil
          end
        end
        data1 = project_hours.compact.sum.round == 0 ? nil : project_hours.compact.sum.round
        data2 = project_cost.compact.sum.round == 0 ? nil : project_cost.compact.sum.round
        data3 = over_all_project_hours.compact.sum.round == 0 ? nil : over_all_project_hours.compact.sum.round
        data4 = over_all_project_cost.compact.sum.round == 0 ? nil : over_all_project_cost.compact.sum.round

        tot_data1 << data1
        tot_data2 << data2
        tot_data3 << data3
        tot_data4 << data4
        
        @project_over_all_data << [project["name"], data1, data2, data3, data4]
      end
      @project_over_all_data << ["Total", tot_data1.compact.sum, tot_data2.compact.sum, tot_data3.compact.sum, tot_data4.compact.sum]
    else
      @project_over_all_data = nil
    end
    return @project_over_all_data
  end

  def self.project_pdf    
    result = Project.get_data("weekly")
    path = "#{Rails.root}/public/weekly_employee_utilisation_report_#{Date.today.strftime('%d-%m-%Y')}.csv"
    CSV.open(path, "wb") do |csv|
      csv << ["Project Cost Report for the week #{(Date.yesterday.beginning_of_week-1).strftime('%a, %d-%b-%Y')} to #{(Date.yesterday.end_of_week-1).strftime('%a, %d-%b-%Y')}"]
      csv << ["Project Name", "Hours (Past week)", "Cost (Past week)", "Overall Hours (Till date)", "Overall Cost (Till date)"]
      result.map do |data|
        csv << data
      end
    end
    @user2={:email=> "poombavai.sivamani@altiussolution.com"}
    ProjectbaseMailer.project_report(@user2,path,type="weekly").deliver
  end  

  def self.monthly_pdf
    result = Project.get_data("monthly")
    path = "#{Rails.root}/public/monthly_project_cost_report_#{Date.today.strftime('%d-%m-%Y')}.csv"
    CSV.open(path, "wb") do |csv|
      csv << ["Projects Cost Report for the month #{(Date.yesterday-1).beginning_of_month.strftime('%a, %d-%b-%Y')} to #{(Date.yesterday-1).end_of_month.strftime('%a, %d-%b-%Y')}"]
      csv << ["Project Name", "Hours (Past week)", "Cost (Past week)", "Overall Hours (Till date)", "Overall Cost (Till date)"]
      result.map do |data|
        csv << data
      end
    end
    @user2={:email=> "poombavai.sivamani@altiussolution.com"}
    ProjectbaseMailer.project_report(@user2,path,type="monthly").deliver
  end

  def self.project_report(params)  	
  	if params["project"]["id"].present? 

  	  project = Project.find(params["project"]["id"])
      @project_over_all_data, over_all_project_hours, over_all_project_cost, project_hours, project_cost = [], [], [], [], []
  	  timesht = TimeSheet.where(:project_id => project["id"])
  	  if timesht.present?
  	    employee_group = timesht.group_by(&:employee_id)
  	    employee_group.map do |employee_id,time_sheet|
  	  	  ctc = Employee.find(employee_id).ctc
  	  	  time = time_sheet.pluck(:hours).sum
  	  	  one_hour = (ctc/24)/8
  	  	  over_all_project_hours << time
  	  	  over_all_project_cost << (time*one_hour)
  	    end
        timesheets = timesht.where(:date => params["from_date"] .. params["to_date"])
        if timesheets.present?
      	  employee_group = timesheets.group_by(&:employee_id)
      	  employee_group.map do |employee_id,time_sheet|
      	    ctc = Employee.find(employee_id).ctc
      	    time = time_sheet.pluck(:hours).sum
      	    one_hour = (ctc/24)/8
      	    project_hours << time
            project_cost << (time*one_hour)
          end 
        else
      	  project_hours << 0
          project_cost << 0 
        end  
      end

      data1 = project_hours.compact.sum.round == 0 ? nil : project_hours.compact.sum.round
      data2 = project_cost.compact.sum.round == 0 ? nil : project_cost.compact.sum.round
      data3 = over_all_project_hours.compact.sum.round == 0 ? nil : over_all_project_hours.compact.sum.round
      data4 = over_all_project_cost.compact.sum.round == 0 ? nil : over_all_project_cost.compact.sum.round

      @project_over_all_data << [project["name"], data1, data2, data3, data4]

  	else

  	  if Project.where(:status => true).present?
  	  	@project_over_all_data = []
      	Project.where(:status => true).map do |project|
          over_all_project_hours = []
          over_all_project_cost = []
          project_hours = []
          project_cost = []
          timesht = TimeSheet.where(:project_id => project["id"])
          if timesht.present?
            employee_group = timesht.group_by(&:employee_id)
            employee_group.map do |employee_id,time_sheet|
              ctc = Employee.find(employee_id).ctc
              time = time_sheet.pluck(:hours).sum
              one_hour = (ctc/24)/8
              over_all_project_hours << time
              over_all_project_cost << (time*one_hour)
            end
            timesheets = timesht.where(:date => params["from_date"] .. params["to_date"]) 
            if timesheets.present?
              employee_group = timesheets.group_by(&:employee_id)
              employee_group.map do |employee_id,time_sheet|
              	ctc = Employee.find(employee_id).ctc
                time = time_sheet.pluck(:hours).sum
                one_hour = (ctc/24)/8
                project_hours << time
                project_cost << (time*one_hour)
              end 
            else
			        project_hours << 0
              project_cost << 0 
            end  
          end

          data1 = project_hours.compact.sum.round == 0 ? nil : project_hours.compact.sum.round
          data2 = project_cost.compact.sum.round == 0 ? nil : project_cost.compact.sum.round
          data3 = over_all_project_hours.compact.sum.round == 0 ? nil : over_all_project_hours.compact.sum.round
          data4 = over_all_project_cost.compact.sum.round == 0 ? nil : over_all_project_cost.compact.sum.round

          @project_over_all_data << [project["name"], data1, data2, data3, data4]
          
      	end
      end

    end

    return @project_over_all_data
  end

end