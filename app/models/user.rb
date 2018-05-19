class User < ApplicationRecord
  has_secure_password
  belongs_to :role
  belongs_to :employee

  require 'byebug'

  def self.generate_auth_token
    token  =  SecureRandom.hex
    token
  end

  def self.overall_report
	  @user = User.new(:email => "tennis.velusamy@altiussolution.com")
	  #MobcomMailer.mail("tennis.velusamy@altiussolution.com").deliver
    ReportMailer.sendmail(@user).deliver
	end

  def self.project_report
    if Project.where(:status => true).present?
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
             one_hour = ctc/24
             over_all_project_hours << time
             over_all_project_cost << (time*one_hour)
          end 
          if TimeSheet.where(:date => (Date.today.beginning_of_week-1..Date.today.end_of_week-1), :approval_status => true, :project_id => project["id"]).present?
            employee_group = TimeSheet.where(:date => (Date.today.beginning_of_week-1..Date.today.end_of_week-1), :approval_status => true, :project_id => project["id"]).group_by(&:employee_id)
            employee_group.map do |employee_id,time_sheet|
              ctc = Employee.find(employee_id).ctc
              time = time_sheet.pluck(:hours).sum
              one_hour = ctc/24
              project_hours << time
              project_cost << (time*one_hour)
            end 
          else
            project_hours << 0
            project_cost << 0 
          end  
        end  
        @project_over_all_data << [project["name"],over_all_project_hours.compact.sum,over_all_project_cost.compact.sum,project_hours.compact.sum,project_cost.compact.sum]
      end
    end    
    @user1 = {:email => "senthil.eswaramoorthi@altiussolution.com", :project => @project_over_all_data}

    ProjectbaseMailer.report(@user1).deliver

    @user2 = {:email => "tennis.velusamy@altiussolution.com", :project => @project_over_all_data}
     
    ProjectbaseMailer.report(@user2).deliver
  end

  def self.employee_project_report
    if Project.where(:status => true).present?
      @project_over_all_data = []
      Project.where(:status => true).map do |project|
        project_data = []
        if TimeSheet.where(:date => (Date.today.beginning_of_week-1.week..Date.today.end_of_week-1), :approval_status => true, :project_id => project["id"]).present?
          date = Date.today.beginning_of_week-1.week
          (0..6).map do |day_count|
            project_hours = []
            project_cost = [] 
            if TimeSheet.where(:date => date+day_count, :approval_status => true, :project_id => project["id"]).present?
              employee_group = TimeSheet.where(:date => date+day_count, :approval_status => true, :project_id => project["id"]).group_by(&:employee_id)
              employee_group.map do |employee_id,time_sheet|
                ctc = Employee.find(employee_id).ctc
                time = time_sheet.pluck(:hours).sum
                one_hour = ctc/24
                project_hours << time
                project_cost << (time*one_hour)
              end 
            end  
            project_data  << [date+day_count,project_hours.sum,project_cost.sum]
          end
          @project_over_all_data << [project["name"],project_data]
        end
      end

      @user1 = {:email =>  "senthil.eswaramoorthi@altiussolution.com",:project => @project_over_all_data}

      EmployeebaseMailer.report(@user1).deliver

      @user2 = {:email =>  "tennis.velusamy@altiussolution.com",:project => @project_over_all_data}
     
      EmployeebaseMailer.report(@user2).deliver
    end
  end

end