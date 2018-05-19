class DailyMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_mailer.notification.subject
  #
  def notification(email)
  	mail(:to => email, :subject => "Time Sheet - TEST")
  end
  
end
