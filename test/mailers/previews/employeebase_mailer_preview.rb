# Preview all emails at http://localhost:3000/rails/mailers/employeebase_mailer
class EmployeebaseMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/employeebase_mailer/report
  def report
    EmployeebaseMailer.report
  end

end
