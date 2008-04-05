class SessionsController < ApplicationController
  
  # POST /sessions
  def create
    @user = User.authenticate(params[:email], params[:password])
    if @user.nil?
      flash[:notice] = 'Invalid login'
      render :action=>:new
    else
      save_to_session
      redirect_to cookbook_path
    end
  end  
  
  # DELETE /sessions
  def destroy
    clear_session
    redirect_to welcome_path
  end
  
end