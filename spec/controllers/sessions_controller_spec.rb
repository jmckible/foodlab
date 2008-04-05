require File.dirname(__FILE__) + '/../spec_helper'

describe SessionsController do
  fixtures :users
  integrate_views
  
  it 'should get login screen' do
    get :new
    response.should be_success
  end
  
  it 'should login a user' do
    user = users(:jordan)
    post :create, :email=>user.email, :password=>'test'
    response.should redirect_to(cookbook_path)
    session[:user_id].should == user.id
  end
  
  it 'should render new on failed login' do
    user = users(:jordan)
    post :create, :email=>user.email, :password=>'wrong password'
    response.should be_success
    response.should render_template(:new)
    session[:user_id].should be_nil
  end
  
  it 'should logout a user' do
    login_as :jordan
    delete :destroy, :id=>users(:jordan)
    #response.should redirect_to(welcome_path)
    session[:user_id].should be_nil
    cookies[:user_id].should be_nil
    cookies[:password_hash].should be_nil
  end
  
end