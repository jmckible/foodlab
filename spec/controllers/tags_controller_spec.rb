require File.dirname(__FILE__) + '/../spec_helper'

describe TagsController do
  fixtures :tags, :taggings, :recipes, :users, :ingredients
  integrate_views
  
  before(:each) do
    @tag = tags(:fast)
  end
  
  it 'should show recipes for a tag' do  
    get :show, :id=>@tag.to_param
    response.should be_success
    assigns(:tag).should == @tag
  end

end
