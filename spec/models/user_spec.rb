require File.dirname(__FILE__) + '/../spec_helper'

describe User, 'the class' do
  fixtures :users
  
  it 'should authenticate a valid login' do
    User.authenticate(users(:jordan).email, 'test').should == users(:jordan)
  end
  
  it 'should not authenticate a valid login' do
    User.authenticate(users(:jordan).email, 'fake').should be_nil
  end
end

describe User, 'valid and saved' do
  fixtures :users, :recipes, :taggings, :tags, :ratings, :comments, :bookmarks
  
  before(:each) do
    @user = users(:jordan)
  end
  
  it 'should be valid' do
    @user.should be_valid
  end
  
  it 'should have a name' do
    @user.name.should == 'Jordan McKible'
  end
  
  ###################################
  #    R E L A T I O N S H I P S    #
  ###################################
  it 'should have many bookmarks' do
    @user.bookmarks.should == bookmarks(:herring_jordan, :pizza_jordan)
  end
  
  it 'should have many bookmarked recipes' do
    @user.bookmarked_recipes == recipes(:herring, :pizza)
  end
  
  it 'should have many comments' do
    @user.comments.should == [comments(:jordan_pizza)]
  end
  
  it 'should have many ratings' do
    @user.ratings.should == ratings(:jordan_pizza, :jordan_herring)
  end
  
  it 'should have many recipes' do
    @user.recipes.should == [recipes(:pizza)]
  end
  
  it 'should have many taggings' do
    @user.taggings.should == taggings(:pizza_baking_jordan, :pizza_fast_jordan, :herring_fast_jordan)
  end
  
  it 'should have many tags' do
    @user.tags.should == tags(:fast, :baking)
  end
  
  ###################################
  #      P R O T E C T I O N        #
  ###################################
  it 'should update password' do
    @user.password = 'newer'
    @user.password_confirmation = 'newer'
    @user.should be_valid
    @user.save!
    User.authenticate(@user.email, 'newer').should == @user
  end
  
  it 'should never be destroyed' do
    lambda {
      lambda{
        @user.destroy.should 
      }.should raise_error
    }.should_not change(User, :count)
  end
  
  it 'should not update timestamps through mass assignment' do
    @user.update_attributes! :created_at=>1.year.from_now, :updated_at=>1.year.from_now
    @user.created_at.should <= Time.now
    @user.updated_at.should <= Time.now
  end
  
  it 'should not update password attributes through mass assignment' do
    @user.update_attributes! :password_hash=>'hash', :password_salt=>'salty', :password_reset_token=>'token'
    @user.password_hash.should_not == 'hash'
    @user.password_salt.should_not == 'salty'
    @user.password_reset_token.should_not == 'token'
  end
  
  it 'should not update recipes through mass assignment' do
    @user.update_attributes! :recipes=>[recipes(:herring)]
    @user.reload.recipes.should == [recipes(:pizza)]
  end
  
  it 'should not update administrator through mass assignment' do
    @user.update_attributes! :administrator=>false
    @user.should be_administrator
  end
end

describe User, 'new' do
  before(:each) do
    @user = User.new
  end
  
  it 'should not be valid' do
    @user.should_not be_valid
  end
  
  it 'should have a valid password' do
    @user.should have(3).errors_on(:email)
  end

  it 'should have a name' do
    @user.should have(1).error_on(:first_name)
    @user.should have(1).error_on(:last_name)
  end

  it 'should have a password' do 
    @user.should have(1).error_on(:password)
    @user.should have(1).error_on(:password_confirmation)
  end
end

describe User, 'clone' do
  fixtures :users
  
  before(:each) do
    @user = users(:jordan).clone
  end
  
  it 'should not be valid' do
    @user.should_not be_valid
  end
  
  it 'should have a unique email' do
    @user.should have(1).error_on(:email)
  end
end