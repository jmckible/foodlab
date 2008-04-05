require File.dirname(__FILE__) + '/../spec_helper'

describe Rating, 'valid and saved' do
  fixtures :ratings, :users, :recipes
  
  before(:each) do
    @rating = ratings(:jordan_pizza)
  end

  it 'should be valid' do
    @rating.should be_valid
  end
  
  it 'should belong to a user' do
    @rating.user.should == users(:jordan)
  end
  
  it 'should belong to a recipe'  do
    @rating.recipe.should == recipes(:pizza)
  end
end

describe Rating, 'new' do
  fixtures :ratings, :users, :recipes
  
  before(:each) do
    @rating = Rating.new
  end
  
  it 'should not be valid' do
    @rating.should_not be_valid
  end
  
  it 'should have a value' do
    @rating.should have(1).error_on(:value)
  end
  
  it 'should have a value greater than 0' do
    @rating.value = 0
    @rating.should_not be_valid
    @rating.should have(1).error_on(:value)
  end
  
  it 'should have a value less than 6' do
    @rating.value = 6
    @rating.should_not be_valid
    @rating.should have(1).error_on(:value)
  end
  
  it 'should update recipe rating on save' do
    recipes(:pizza).rating.should == 5
    @rating.value = 1
    @rating.user = users(:dave)
    @rating.recipe = recipes(:pizza)
    @rating.should be_valid
    @rating.save
    recipes(:pizza).reload.rating.should == 3
  end
  
  it 'should have a user' do
    @rating.should have(1).error_on(:user)
  end
  
  it 'should have a recipe' do
    @rating.should have(1).error_on(:recipe)
  end
end
