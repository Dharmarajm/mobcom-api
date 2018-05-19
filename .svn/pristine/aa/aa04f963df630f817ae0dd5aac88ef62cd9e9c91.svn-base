class UsersController < ApplicationController
 def new
    @user = User.new
  end

  def create
    @user = User.new(allowed_params)
    if @user.save
      redirect_to root_url, notice: 'Thank you for signing up!'
    else
      render :new
    end
  end

  def new_password
   render :layout=>false
  end  

  def change_password

  end  

  def change_password_update
      @user = User.find_by(id: session[:user_id])
    if @user && @user.authenticate(params["change password"]["old_password"]).present?
       User.find_by(id: session[:user_id]).update(:password=>params["password"],:password_confirmation=>params["password"])
      redirect_to root_url
    else
      render users_change_password_path
    end
  end  

  def old_password_check
     user=User.find(session[:user_id])
    if user && user.authenticate(params[:password])
       @data="1"
    else
       @data="0"    
    end  
  end



   def set_new_password
   User.find(params["set password"]["id"]).update(:password=>params["NPassword"],:password_confirmation=>params["NPassword"])
   redirect_to root_url
   end  


  private

  def allowed_params
    piarams.require(:user).permit(:email, :password_digest, :role_id, :employee_id)
  end
end
