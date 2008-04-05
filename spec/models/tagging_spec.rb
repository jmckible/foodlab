require File.dirname(__FILE__) + '/../spec_helper'

describe Tagging, 'valid and saved' do
  fixtures :taggings, :tags, :users, :recipes
  
  before(:each) do
    @tagging = taggings(:pizza_fast_jordan)
  end
  
  it 'should be valid' do
    @tagging.should be_valid
  end
  
  it 'should have a tag' do
    @tagging.tag.should == tags(:fast)
  end
  
  it 'should have a user' do
    @tagging.user.should == users(:jordan)
  end
  
  it 'should have a recipe' do
    @tagging.recipe.should == recipes(:pizza)
  end
end

describe Tagging, 'new' do
  fixtures :taggings, :tags, :users, :recipes
  
  before(:each) do
    @tagging = Tagging.new
  end

  it 'should not be valid' do
    @tagging.should_not be_valid
  end
  
  it 'should have a tag' do
    @tagging.should have(1).error_on(:tag)
  end
  
  it 'should have a user' do
    @tagging.should have(1).error_on(:user)
  end
  
  it 'should have a recipe' do
    @tagging.should have(1).error_on(:recipe)
  end
  
  it 'should increment tagging_count on save' do
    @tag = tags(:fish)
    @tagging.tag = @tag
    @tagging.user = users(:jordan)
    @tagging.recipe = recipes(:herring)
    
    old_count = @tag.taggings_count
    @tagging.should be_valid
    @tagging.save
    @tag.reload.taggings_count.should == old_count + 1
  end
end

describe Tagging, 'clone' do
  fixtures :taggings, :tags, :users, :recipes
  
  before(:each) do
    @tagging = taggings(:pizza_fast_jordan).clone
  end

  it 'should not be valid' do
    @tagging.should_not be_valid
  end

  it 'should have unique tag' do
    @tagging.should have(1).error_on(:tag_id)
  end
end

describe Tagging, 'to be destroyed' do
  fixtures :taggings, :tags, :users, :recipes
  
  before(:each) do
    @tagging = taggings(:pizza_fast_jordan)
    @tag = @tagging.tag
  end
  
  it 'should decrement tag count' do
    old_count = @tag.taggings_count
    @tagging.destroy
    @tag.reload.taggings_count.should == old_count - 1
  end
end

describe Tagging, 'new recipe for a user' do
  fixtures :taggings, :tags, :users, :recipes, :bookmarks
  
  before(:each) do
    @user = users(:dave)
    @recipe = recipes(:herring)
  end
  
  it 'should create a new bookmark' do
    lambda{
      @recipe.add_user_tags! @user, 'new tag'
    }.should change(Bookmark, :count)
  end
  
end

describe Tagging, 'user has already tagged the recipe' do
  fixtures :taggings, :tags, :users, :recipes, :bookmarks
  
  before(:each) do
    @user = users(:jordan)
    @recipe = recipes(:herring)
  end
  
  it 'should create a new bookmark' do
    lambda{
      @recipe.add_user_tags! @user, 'new tag'
    }.should_not change(Bookmark, :count)
  end
  
end