# Preview all emails at http://localhost:3000/rails/mailers/projectbase_mailer
class ProjectbaseMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/projectbase_mailer/report
  def report
    ProjectbaseMailer.report
  end

end
