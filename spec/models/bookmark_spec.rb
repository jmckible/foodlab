require File.dirname(__FILE__) + '/../spec_helper'

describe Bookmark, 'valid and saved' do
  fixtures :bookmarks, :users, :recipes
  
  before(:each) do
    @bookmark = bookmarks(:pizza_jordan)
  end

  it 'should be valid' do
    @bookmark.should be_valid
  end
  
  it 'should belong to a user' do
    @bookmark.user.should == users(:jordan)
  end
  
  it 'should belong to a recipe' do
    @bookmark.recipe.should == recipes(:pizza)
  end

end

describe Bookmark, 'new' do
  before(:each) do
    @bookmark = Bookmark.new
  end
  
  it 'should not be valid' do
    @bookmark.should_not be_valid
  end
  
  it 'should belong to a user' do
    @bookmark.should have(1).error_on(:user)
  end
  
  it 'should belong to a recipe' do
    @bookmark.should have(1).error_on(:recipe)
  end
end

describe Bookmark, 'clone' do
  fixtures :bookmarks
  
  before(:each) do
    @bookmark = bookmarks(:pizza_jordan).clone
  end
  
  it 'should not be valid' do
    @bookmark.should_not be_valid
  end
  
  it 'should require a unique recipe' do
    @bookmark.should have(1).error_on(:recipe_id)
  end
end