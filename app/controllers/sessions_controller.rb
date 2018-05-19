class SessionsController < ApplicationController

  skip_before_action :check_session, only:[:new, :create]

  def new
    if session[:user_id].present?# and !User.find_by(id: session[:user_id]).nil?
      #user  = User.find(session[:user_id])
      redirect_to clients_dashboard_path
    else
      @user = User.new
      render :layout => false
    end
  end

  def create
    user = User.find_by(email: params["new session"]["email"],:role_id=>Role.where(:name=>"Admin").ids[0])
    if user && user.authenticate(params["new session"]["password"])
      session[:user_id] = user.id
      redirect_to clients_dashboard_path
      flash[:notice] = "Logged in"
    else
      redirect_to root_url
      flash[:notice] = 'Email or password is invalid'    
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
    #flash[:notice] = "Logged out"
  end

end
