require File.dirname(__FILE__) + '/../spec_helper'

describe CommentsController, 'as user' do
  fixtures :users, :comments, :recipes
  integrate_views
  
  before(:each) do
    login_as :jordan
    @recipe = recipes(:pizza)
    @emails = ActionMailer::Base.deliveries
  end
  
  it 'should get new' do
    get :new, :recipe_id=>@recipe.id
    response.should be_success
  end
  
  it 'should create a comment and send notification' do
    lambda {
      post :create, :recipe_id=>@recipe.id, :comment=>{:body=>'new'}
      response.should redirect_to(recipe_path(@recipe))
      @emails.size.should == 1
    }.should change(Comment, :count)
  end

end

