require File.dirname(__FILE__) + '/../spec_helper'

describe RecipesController, 'as visitor' do
  fixtures :recipes
  integrate_views
  
  it 'should get index' do
    get :index
    response.should be_success
    assigns(:recipes).should_not be_nil
  end
  
  it 'should redirect to login on get new' do
    get :new
    response.should redirect_to(new_session_path)
  end
  
  it 'should not create a recipe' do
    lambda {
     post :create, :recipe=>{:name=>'New', :process=>'make it'}
     response.should redirect_to(new_session_path)
    }.should_not change(Recipe, :count)
  end
  
  it 'should show a recipe' do
    get :show, :id=>recipes(:pizza)
    response.should be_success
    assigns(:recipe).should == recipes(:pizza)
  end
  
end

describe RecipesController, 'as user' do
  fixtures :users, :recipes
  integrate_views
   
  before(:each) do
    login_as :dave
    @recipe = recipes(:herring)
  end
  
  it 'should get index' do
    get :index
    response.should be_success
    assigns(:recipes).should_not be_nil
  end
  
  it 'should get new' do
    get :new
    response.should be_success
  end
  
  it 'should create a recipe' do
    lambda {
      post :create, :recipe=>{:name=>'Food', :process=>'how its done'}
      response.should redirect_to(recipe_path(assigns(:recipe)))
    }.should change(Recipe, :count)
  end
  
  it 'should render new on failed recipe create' do
    lambda {
      post :create
      response.should be_success
      response.should render_template(:new)
    }.should_not change(Recipe, :count)
  end
  
  it 'should show a recipe' do
    get :show, :id=>@recipe
    response.should be_success
    assigns(:recipe).should == @recipe
  end
  
  it 'should get edit' do
    get :edit, :id=>@recipe
    response.should be_success
    assigns(:recipe).should == @recipe
  end
  
  it 'should update a recipe' do
    old_name = @recipe.name
    put :update, :id=>@recipe, :recipe=>{:name=>'New'}
    assigns(:recipe).id.should == @recipe.id
    response.should redirect_to(recipe_path(assigns(:recipe)))
    assigns(:recipe).name.should_not == old_name
  end
  
  it 'should should render edit on failed update' do
    old_name = @recipe.name
    put :update, :id=>@recipe, :recipe=>{:name=>''}
    response.should render_template(:edit)
    @recipe.reload.name.should == old_name
  end
  
  it 'should add tags' do
    lambda{
      put :add_tags, :id=>@recipe, :tags=>'delicious'
    }.should change(Tag, :count)
  end
end