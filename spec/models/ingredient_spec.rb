require File.dirname(__FILE__) + '/../spec_helper'

describe Ingredient, 'the class' do
  fixtures :ingredients
  
  it 'should find popular' do
    Ingredient.popular.should == ingredients(:flour, :herring, :water)
  end
end

describe Ingredient, 'valid and saved' do
  fixtures :ingredients, :requirements, :recipes
  
  before(:each) do
    @ingredient = ingredients(:water)
  end

  it 'should be valid' do
    @ingredient.should be_valid
  end
  
  it 'should have many requirements' do
    @ingredient.requirements.should == [requirements(:pizza_water)]
  end
  
  it 'should have many recipes' do
    @ingredient.recipes.should == [recipes(:pizza)]
  end
  
  it 'should not update requirements through mass assignement' do
    @ingredient.update_attributes! :requirements=>[requirements(:herring_herring)]
    @ingredient.requirements.should == [requirements(:pizza_water)]
  end
  
  it 'should not update timestamps through mass assignment' do
    @ingredient.update_attributes! :created_at=>1.year.from_now, :updated_at=>1.year.from_now
    @ingredient.created_at.should <= Time.now
    @ingredient.updated_at.should <= Time.now
  end
  
  it 'should use url as to_param' do
    @ingredient.to_param.should == @ingredient.url
  end
  
  it 'should strip name on save' do
    @ingredient.name = ' strip '
    @ingredient.save
    @ingredient.reload.name.should == 'strip'
  end

end

describe Ingredient, 'new' do
  before(:each) do
    @ingredient = Ingredient.new
  end
  
  it 'should be not be valid' do
    @ingredient.should_not be_valid
  end
  
  it 'should have a name' do
    @ingredient.should have(1).error_on(:name)
  end
  
  it 'should have a url' do
    @ingredient.should have(1).error_on(:url)
  end
  
  it 'should generate url on validate' do
    @ingredient.name = 'french fries'
    @ingredient.should be_valid
    @ingredient.url.should == 'french-fries'
  end
end

describe Ingredient, 'clone' do
  fixtures :ingredients
  
  before(:each) do
    @ingredient = ingredients(:water).clone
  end
  
  it 'should not be valid' do
    @ingredient.should_not be_valid
  end
  
  it 'should require a unique name' do
    @ingredient.should have(1).error_on(:name)
  end
end
  