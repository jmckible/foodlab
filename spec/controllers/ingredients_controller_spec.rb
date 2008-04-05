require File.dirname(__FILE__) + '/../spec_helper'

describe IngredientsController, 'as visitor' do
  fixtures :recipes, :users, :ingredients, :requirements
  integrate_views
  
  before(:each) do
    @ingredient = ingredients(:flour)
  end
  
  it 'should show recipes for an ingredient' do  
    get :show, :id=>@ingredient.to_param
    response.should be_success
    assigns(:ingredient).should == @ingredient
  end

end

describe IngredientsController, 'as administrator' do
  fixtures :ingredients, :users
  
  before(:each) do
    login_as :jordan
    @ingredient = ingredients(:flour)
  end
  
  it 'should update name' do
    old_name = @ingredient.name
    put :update, :id=>@ingredient.to_param, :ingredient=>{:name=>'new'}
    #response.should redirect_to(ingredient_path(@ingredient))
    @ingredient.reload.should_not == old_name
  end
  
end