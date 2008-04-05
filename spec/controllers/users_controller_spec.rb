require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController, 'as visitor' do
  fixtures :users, :recipes
  integrate_views

  it 'should show a user' do
    get :show, :id=>users(:jordan)
    response.should be_success
    assigns(:user).should_not be_nil
    assigns(:recipes).should_not be_nil
  end
  
  it 'should get new' do
    get :new
    response.should be_success
    assigns(:user).should_not be_nil
  end
  
  it 'should create a user' do
    lambda {
      post :create, :user=>{:first_name=>'new', :last_name=>'guy', :email=>'new@new.com', :password=>'test', :password_confirmation=>'test'}
      response.should redirect_to(cookbook_path)
    }.should change(User, :count)
  end
  
  it 'should render new on failed user creation' do
    lambda {
      post :create, :user=>{:first_name=>'', :last_name=>'guy', :email=>'new@new.com', :password=>'test', :password_confirmation=>'test'}
      response.should be_success
      response.should render_template(:new)
    }.should_not change(User, :count)
  end
  
  it 'should not get edit' do
    get :edit, :id=>users(:jordan)
    response.should redirect_to(new_session_path)
  end
  
  it 'should not update user settings' do
    old_name = users(:jordan).first_name
    put :update, :id=>users(:jordan), :user=>{:first_name=>'new'}
    response.should redirect_to(new_session_path)
    users(:jordan).reload.first_name.should == old_name
  end
end

describe UsersController, 'as a user' do
  fixtures :users, :recipes
  integrate_views
  
  before(:each) do
    login_as :jordan
    @user = users(:jordan)
  end
  
  it 'should get edit for self' do
    get :edit, :id=>@user
    response.should be_success
    assigns(:user).should == @user
  end
  
  it 'should get edit for self as someone else' do
    get :edit, :id=>users(:dave)
    response.should be_success
    assigns(:user).should == @user
  end
  
  it 'should update user info' do
    old_name = @user.first_name
    put :update, :id=>@user, :user=>{:first_name=>'new'}
    @user.reload.first_name.should_not == old_name
  end
end
