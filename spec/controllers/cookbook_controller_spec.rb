require File.dirname(__FILE__) + '/../spec_helper'

describe CookbookController, 'as user' do
  fixtures :users, :recipes
  integrate_views
  
  before(:each) do
    login_as :jordan
  end

  it 'should get index' do
    get :index
    response.should be_success
  end

end

describe CookbookController, 'as visitor' do
  it 'should not get index' do
    get :index
    response.should redirect_to(new_session_path)
  end
end
