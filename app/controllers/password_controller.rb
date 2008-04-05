class PasswordController < ApplicationController
  
  # GET /password/forgot
  def forgot
  end
  
  # POST /password/request
  def send_new
    user = User.find_by_email(params[:email])
    if user.nil?
      flash[:notice] = 'Invalid email'
      render :action=>:forgot and return
    end
    user.password_reset_token = Generator.random_string
    user.save!
    UserNotifier.deliver_request_new_password(user)
  end
  
  # GET /password/reset?token=123456
  def reset
    unless params[:token].nil?
      @user = User.find_by_password_reset_token params[:token]
      unless @user.nil?
        token = Generator.random_string
        @user.password = token
        @user.password_confirmation = token
        @user.save
        UserNotifier.deliver_new_password(@user, token)
      end
    end
  end
  
end
