set :output, "log/cron_log.log"

every '0 10 1 * *' do
  runner "Project.monthly_pdf", :environment => :development
  runner "Employee.monthly_pdf", :environment => :development
end

every '0 10 * * 0' do
  runner "Project.project_pdf", :environment => :development
  runner "Employee.employee_pdf", :environment => :development
end

every '45 17 * * *' do
  runner "Employee.employee_not_entered_timesheet", :environment => :development
end
