require File.dirname(__FILE__) + '/../spec_helper'

describe PublicController do
  integrate_views

  it 'should get index' do
    get :index
    response.should be_success
  end
  
  it 'should do a search' do
    post :search, :query=>'pizza'
    response.should be_success
  end
  
end
