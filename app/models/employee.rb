class Employee < ApplicationRecord
  require 'carrierwave'
  require 'csv'
  require 'activerecord-import'
  require 'rubygems'
  require 'roo'
  require 'spreadsheet'
  mount_uploader :image, AvatarUploader
  has_many :project_employees, dependent: :destroy
  has_many :time_sheets, dependent: :destroy
  has_one :user, dependent: :destroy
  validates_uniqueness_of :email
  validates_length_of :mobile_number,:in => 10..10, :on => :create
  validates :email, uniqueness: { case_sensitive: false}, length: { in: 6..100 }
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

  def self.import_data(params)

    extn=File.extname(params["employee"]["address"].tempfile)
    extn=extn.downcase
    if extn == ".xlsx"
       file = Roo::Spreadsheet.open(params["employee"]["address"].tempfile)
       file = file.sheet(file.sheets.first)
       rows = file.map { |e| e }
    elsif extn == ".xls"
       file=Spreadsheet.open(params["employee"]["address"].tempfile)
       rows=file.worksheet(0).map{|kk| kk}
    elsif extn == ".csv"   
       rows=File.open(params["employee"]["address"].tempfile,"r").collect{|i| i.chomp.split(",")}     
    else
       return "Invalid File"   
    end   
    headers = rows.shift.count  
    if headers == 13
      array = []
      rows.map do |i| 
        array << i[3]
      end
      if Employee.where(email: array.compact).present?
        email = Employee.where(email: array.compact).pluck(:email)
        array = array.join(",")
        return "File Is Invalid ,"" #{email} "" Contains invalid data"
      else
        rows.map do |i| 
          Employee.create(first_name: i[0], last_name: i[1], mobile_number: i[2].to_s.split(".")[0], email: i[3], employee_id: i[4], designation: i[5], ctc: i[6], date_of_birth: i[7], street: i[8], pincode: i[9], city: i[10], state: i[11], country: i[12])
        end   
        return "File Is Successfully Uploaded"        
      end   
    else
      return "Invalid Headers"
    end  	
  end

  def self.employee_report(params)
    employee_id = params["employee_id"]
    status = params["approval_status"]
    if status == "All" or status.nil?
      approval_status = [true, false, nil]
    elsif status == "Approved"
      approval_status = true
    else
      approval_status = [false, nil]
    end
    if employee_id.present?
      fromdate = params["from_date"]
      todate = params["to_date"]
      @employee_data = []
      emp_id = employee_id
      @emp_data = []
      @emp_data << Employee.find(emp_id).first_name
      date_wise_data = []
      (fromdate.to_date..todate.to_date).to_a.map do |date|
        time_sht = TimeSheet.where(date: date, employee_id: emp_id)
        if time_sht.present?
          if time_sht.pluck(:attendance_log).include?(false)
            emp_hours = "A"
            emp_cost = "A"
          else
            emp_hours = time_sht.where(approval_status: approval_status).pluck(:hours).compact.sum.round
            ctc = Employee.find(emp_id).ctc
            one_hour = (ctc/24)/8
            emp_cost = emp_hours * one_hour
          end
        else
          emp_hours = ""
          emp_cost = ""
        end
        date_wise_data << [date,emp_hours,emp_cost]
      end
      @emp_data << date_wise_data
      @employee_data << @emp_data
    else
      @employee_data = []
      fromdate = params[:from_date]
      todate = params[:to_date]
      employee_id = ProjectEmployee.pluck(:employee_id).uniq      
      employee_id.map do |emp_id|
        @emp_data = []
        @emp_data << Employee.find(emp_id).first_name
        date_wise_data = []
        (fromdate.to_date..todate.to_date).to_a.map do |date|
          time_sht = TimeSheet.where(date: date, employee_id: emp_id)
          if time_sht.present?
            if time_sht.pluck(:attendance_log).include?(false)
              emp_hours = "A"
              emp_cost = "A"
            else
              emp_hours = time_sht.where(approval_status: approval_status).pluck(:hours).compact.sum.round
              ctc = Employee.find(emp_id).ctc
              one_hour = (ctc/24)/8
              emp_cost = emp_hours * one_hour
            end
          else
            emp_hours = ""
            emp_cost = ""
          end
          date_wise_data << [date,emp_hours,emp_cost]
        end
        @emp_data << date_wise_data
        @employee_data << @emp_data
      end
    end
    return @employee_data, fromdate, todate
  end

  def self.employee_not_entered_timesheet
    admin_id =Role.find_by_name("Admin").id
    all_employees = User.where.not(role_id: admin_id).pluck(:employee_id).uniq
    if TimeSheet.where(date: Date.today).present?      
      employee_ids = TimeSheet.where(date: Date.today).pluck(:employee_id).uniq
      emp_ids = all_employees-employee_ids
      email_ids = Employee.where(id: emp_ids).pluck(:email)
    else
      email_ids = Employee.where(id: all_employees).pluck(:email)
    end
    unless email_ids.empty?
      email_ids.map do |email|
        DailyMailer.notification(email).deliver
      end
    end    
  end

  def self.get_data(report)
    report_type = report
    if report_type == "weekly"
      @dates = (Date.yesterday.beginning_of_week-1..Date.yesterday.end_of_week-1)
    elsif report_type == "monthly"
      @dates = ((Date.yesterday-1).beginning_of_month..(Date.yesterday-1).end_of_month)
    end
    if ProjectEmployee.present?
      @employee_data = []
      employee_id = ProjectEmployee.pluck(:employee_id).uniq
      employee_id.map do |emp_id|
        @emp_data = []
        @emp_data << Employee.find(emp_id).first_name
        date_wise_data = []
        @dates.map do |date|
          time_sht = TimeSheet.where(date: date, employee_id: emp_id, approval_status: true)
          if time_sht.present?
            if time_sht.pluck(:attendance_log).include?(false)
              emp_hours = "A"
              emp_cost = "A"
            else
              emp_hours = time_sht.pluck(:hours).compact.sum.round
              ctc = Employee.find(emp_id).ctc
              one_hour = (ctc/24)/8
              emp_cost = emp_hours  * one_hour
            end
          else
            emp_hours = ""
            emp_cost = ""
          end
          #date_wise_data << [date, emp_hours, emp_cost]
          date_wise_data << [emp_hours]
        end
        total = date_wise_data.flatten.map{|i| i.to_f}.sum.round
        @emp_data << date_wise_data
        @emp_data << total
        @employee_data << @emp_data.flatten
      end
    else
      @employee_data = nil
    end
    return @employee_data
  end

  def self.employee_pdf    
    result = Employee.get_data("weekly")

    p = Axlsx::Package.new
    ws = p.workbook.add_worksheet(:name => "Employee weekly Report")
    title = ws.styles.add_style(:b => true, :alignment=>{:horizontal => :center})

    ws.add_row ["Employee Utilization for the week #{(Date.yesterday.beginning_of_week-1).strftime('%a, %d-%b-%Y')} to #{(Date.yesterday.end_of_week-1).strftime('%a, %d-%b-%Y')}"], :style => title

    headers = ["Employee Name"]
    ((Date.yesterday.beginning_of_week-1)..(Date.yesterday.end_of_week-1)).map do |e|
      headers << e.to_date.strftime("%d-%b").to_s
    end
    headers << "Total"
    
    ws.add_row headers, :style => title
    result.each do |data|
      row = ws.add_row
      data.each do |val|
        row.add_cell val
      end
    end

    ws.merge_cells "A1:I1"
    path = "#{Rails.root}/public/weekly_employee_utilisation_report_#{Date.today.strftime('%d-%m-%Y')}.xlsx"    
    p.serialize(path)
    @user2={:email=> "poombavai.sivamani@altiussolution.com"}
    ProjectbaseMailer.report(@user2,path,type="weekly").deliver
  end  

  def self.monthly_pdf
    result = Employee.get_data("monthly")

    p = Axlsx::Package.new
    ws = p.workbook.add_worksheet(:name => "#{(Date.yesterday-1).strftime("%B-%Y").to_s}")
    title1 = ws.styles.add_style(:b => true, :alignment=>{:horizontal => :center}, :sz => 16)
    title2 = ws.styles.add_style(:b => true, :alignment=>{:horizontal => :center}, :sz => 14)

    ws.add_row ["Employee Utilization for the month #{(Date.yesterday-1).beginning_of_month.strftime('%a, %d-%b-%Y')} to #{(Date.yesterday-1).end_of_month.strftime('%a, %d-%b-%Y')}"], :style => title1

    headers = ["Employee Name"]
    (((Date.yesterday-1).beginning_of_month.to_date .. (Date.yesterday-1).end_of_month.to_date).to_a).map do |date|
        headers << date.strftime("%d")
      end
    headers << "Total"
    
    ws.add_row headers, :style => title2
    result.each do |data|
      row = ws.add_row
      data.each do |val|
        row.add_cell val
      end
    end

    ws.merge_cells "A1:I1"
    path = "#{Rails.root}/public/monthly_employee_utilisation_report_#{Date.today.strftime('%d-%m-%Y')}.xlsx"    
    p.serialize(path)
    @user2={:email=> "poombavai.sivamani@altiussolution.com"}
    ProjectbaseMailer.report(@user2,path,type="monthly").deliver
  end    

end