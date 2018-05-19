class ProjectbaseMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.projectbase_mailer.report.subject
  #
  def report(user,path, type)
    @user=user
    @path=path
    @data=@user[:project]

    if type == "weekly"

      attachments["weekly_employee_utilisation_report_#{Date.today.strftime('%d-%m-%Y')}.xlsx"] = File.read(@path)
      mail(:to => @user[:email], :subject => "Employee Utilization for the week #{(Date.yesterday.beginning_of_week-1).strftime('%a, %d-%b-%Y')} to #{(Date.yesterday.end_of_week-1).strftime('%a, %d-%b-%Y')}")

    elsif type == "monthly"

      attachments["monthly_employee_utilisation_report_#{Date.today.strftime('%d-%m-%Y')}.xlsx"] = File.read(@path)
      mail(:to => @user[:email], :subject => "Employee Utilization for the month #{Date.yesterday.beginning_of_month.strftime('%a, %d-%b-%Y')} to #{(Date.yesterday.end_of_month).strftime('%a, %d-%b-%Y')}")

    end

  end

  def project_report(user,path, type)
    @user=user
    @path=path
    @data=@user[:project]

    if type == "weekly"

      attachments['weekly_project_cost_report.xlsx'] = File.read(@path)
      mail(:to => @user[:email], :subject => "Project Cost Report for the week #{(Date.yesterday.beginning_of_week-1).strftime('%a, %d-%b-%Y')} to #{(Date.yesterday.end_of_week-1).strftime('%a, %d-%b-%Y')}")

    elsif type == "monthly"

      attachments['monthly_project_cost_report.xlsx'] = File.read(@path)
      mail(:to => @user[:email], :subject => "Projects Cost Report for the month #{Date.yesterday.beginning_of_month.strftime('%a, %d-%b-%Y')} to #{(Date.yesterday.end_of_month).strftime('%a, %d-%b-%Y')}")

    end
  end

end