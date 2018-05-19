class EmployeebaseMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.employeebase_mailer.report.subject
  #
  def report(user)
    @user=user
    @data=@user[:project]
    mail to: @user[:email]
  end
end
