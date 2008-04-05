require File.dirname(__FILE__) + '/../spec_helper'

describe RatingsController, 'as user' do
  fixtures :users, :ratings, :recipes
  integrate_views
  
  before(:each) do
    @rating = ratings(:jordan_pizza)
  end
  
  it 'should create a rating' do
    login_as :bill
    lambda{
      post :create, :recipe_id=>recipes(:pizza).id, :value=>4
    }.should change(Rating, :count)
  end
  
  it 'should upadate a rating' do
    login_as :jordan
    put :update, :id=>@rating, :value=>1
    @rating.reload.value.should == 1
  end
 
end