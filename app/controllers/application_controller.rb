class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  #before_action :current_user, :except => ["login","new_password"]
  before_action :check_session
  helper_method :current_user
    
  #def check_session
  # if session[:user_id].blank?
  #   redirect_to root_path
  # end
  #end

  def check_session
    redirect_to root_path unless current_user
  end

  private

    def current_user
      if session[:user_id].present?
        unless User.find_by(id: session[:user_id]).nil?
          @current_user ||= User.find_by(id: session[:user_id])
        else
          @current_user = nil
        end
      else
        session[:user_id] = nil
      end
    end

=begin
    if session[:user_id]
      unless User.find_by(id: session[:user_id]).nil?
        @current_user ||= User.find_by(id: session[:user_id])
      else
        @current_user = nil
      end
    end
=end

end