require File.dirname(__FILE__) + '/../spec_helper'

describe PasswordController do
  fixtures :users
  
  before(:each) do
    @user = users(:jordan)
  end

  it 'should show forgot password page' do
    get :forgot
    response.should be_success
  end
  
  it 'should request new password' do
    @user.password_reset_token.should be_nil
    post :send_new, :email=>@user.email
    response.should be_success
    @user.reload.password_reset_token.should_not be_nil
  end
  
  it 'should render forgot on unknown reset request' do
    post :send_new, :email=>'fake'
    response.should be_success
    response.should render_template(:forgot)
  end
  
  it 'should reset password on confirmation' do
    @user.password_reset_token = 'token'
    @user.save
    get :reset, :token=>'token'
    response.should be_success
    User.authenticate(@user.email, 'test').should be_nil
  end
  
  it 'should not reset password on failed confirmation' do
    @user.password_reset_token = 'token'
    @user.save
    get :reset, :token=>'fake'
    response.should be_success
    User.authenticate(@user.email, 'test').id.should == @user.id 
    assigns(:user).should be_nil
  end
  
  it 'should do nothing with no confirmation token' do
    get :reset
    response.should be_success
    assigns(:user).should be_nil
  end

end
