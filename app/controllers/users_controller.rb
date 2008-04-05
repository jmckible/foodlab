class UsersController < ApplicationController
  before_filter :login_required, :only=>[:edit, :update]

  # GET /users/1
  def show
    @user = User.find params[:id]
    @recipes = @user.recipes.paginate :page=>params[:page]
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  def create
    @user = User.new(params[:user])
    @user.save!
    save_to_session
    redirect_to cookbook_path
  rescue ActiveRecord::RecordInvalid
    render :action=>:new
  end
  
  # GET /users/edit
  def edit
    @user = current_user
  end
  
  # PUT /users/1
  def update
    @user = current_user
    @user.update_attributes! params[:user]
    flash[:notice] = 'Settings updated'
    render :action=>:edit
  rescue ActiveRecord::RecordInvalid
    render :action=>:edit
  end

end
