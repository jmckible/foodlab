require File.dirname(__FILE__) + '/../spec_helper'

describe TaggingsController, 'as user' do
  fixtures :users, :taggings
  integrate_views
  
  before(:each) do
    login_as :jordan
    @tagging = taggings(:pizza_fast_jordan)
  end
  
  it 'should delete' do
    lambda {
      delete :destroy, :id=>@tagging
    }.should change(Tagging, :count)
  end
  
end
