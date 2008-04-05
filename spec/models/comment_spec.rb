require File.dirname(__FILE__) + '/../spec_helper'

describe Comment, 'valid and saved' do
  fixtures :comments, :recipes, :users
  
  before(:each) do
    @comment = comments(:jordan_pizza)
  end

  it 'should be valid' do
    @comment.should be_valid
  end
  
  it 'should belong to a user' do
    @comment.user.should == users(:jordan)
  end
  
  it 'should belong to a recipe' do
    @comment.recipe.should == recipes(:pizza)
  end
  
  it 'should respond to textiled' do
    @comment.should respond_to(:textiled)
  end
  
end

describe Comment, 'new' do
  
  before(:each) do
    @comment = Comment.new
  end
  
  it 'should not be valid' do
    @comment.should_not be_valid
  end
  
  it 'should belong to a user' do
    @comment.should have(1).error_on(:user)
  end
  
  it 'should belong to a recipe' do
    @comment.should have(1).error_on(:recipe)
  end
  
  it 'should have a body' do
    @comment.should have(1).error_on(:body)
  end
  
end