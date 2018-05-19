class ReportMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.report_mailer.sendmail.subject
  #
 def sendmail(user)
    @user=user
    @user_id=user.id

    mail to: @user.email
  end
end
