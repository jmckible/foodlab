require File.dirname(__FILE__) + '/../spec_helper'

describe Requirement, 'valid and saved' do
  fixtures :requirements, :recipes, :ingredients
  
  before(:each) do
    @requirement = requirements(:pizza_water)
  end
  
  it 'should be valid' do
    @requirement.should be_valid
  end
  
  it 'should belong to a recipe' do
    @requirement.recipe.should == recipes(:pizza)
  end
  
  it 'should belong to an ingredient' do
    @requirement.ingredient.should == ingredients(:water)
  end
  
  it 'should not update relationships through mass assignment' do
    @requirement.update_attributes! :recipe=>recipes(:herring), :ingredient=>ingredients(:flour)
    @requirement.recipe.should == recipes(:pizza)
    @requirement.reload.ingredient.should == ingredients(:water)
  end
  
  it 'should act as list' do
    @requirement.should respond_to(:position)
  end
  
  it 'should have a name accessor to ingredient' do
    @requirement.name.should == 'water'
  end
  
  it 'should assign existing ingredient through name' do
    @requirement.name = 'flour'
    @requirement.ingredient.should == ingredients(:flour)
  end
  
  it 'should assign new ingredient through name' do
    @requirement.name = 'squid'
    @requirement.ingredient.name.should == 'squid'
  end
  
  it 'should ignore ingredient creation on blank name' do
    @requirement.name = ''
    @requirement.ingredient.should == ingredients(:water)
  end
  
  it 'should ignore ingredient creation on nil name' do
    @requirement.name = nil
    @requirement.ingredient.should == ingredients(:water)
  end
end

describe Requirement, 'new' do
  fixtures :ingredients, :recipes, :requirements
  
  before(:each) do
    @requirement = Requirement.new
  end
  
  it 'should not be valid' do
    @requirement.should_not be_valid
  end
  
  it 'should belong to a recipe' do
    @requirement.should have(1).error_on(:recipe)
  end
  
  it 'should belong to an ingredient' do
    @requirement.should have(1).error_on(:ingredient)
  end

  it 'should have an empty name placeholder' do
    @requirement.name.should be_nil
  end
  
  it 'should assign existing ingredient through name' do
    @requirement.name = 'flour'
    @requirement.ingredient.should == ingredients(:flour)
  end
    
  it 'should assign new ingredient through name' do
    @requirement.name = 'squid'
    @requirement.name.should == 'squid'
  end
  
  it 'should increment requirements_count on save' do
    @ingredient = ingredients(:herring)
    @requirement.ingredient = @ingredient
    @requirement.recipe = recipes(:pizza)
    @requirement.should be_valid
    
    old_count = @ingredient.requirements_count
    @requirement.save
    @ingredient.reload.requirements_count.should == old_count +1
  end
end

describe Requirement, 'built through recipe (like in controller)' do
  fixtures :ingredients, :recipes
  
  it 'should create with existing ingredient' do
    lambda{
      requirement = recipes(:pizza).requirements.build :name=>ingredients(:herring).name, :quantity=>2
      requirement.should be_valid
      requirement.recipe.should == recipes(:pizza)
      requirement.ingredient.should == ingredients(:herring)
      requirement.save!
    }.should change(Requirement, :count)
  end
  
  it 'should create with new ingredient' do
    lambda{
      lambda{
        requirement = recipes(:pizza).requirements.build :name=>'sucrose', :quantity=>2
        requirement.should be_valid
        requirement.recipe.should == recipes(:pizza)
        requirement.ingredient.name.should == 'sucrose'
        requirement.save!
      }.should change(Ingredient, :count)
    }.should change(Requirement, :count)
  end
end

describe Requirement, 'to be destroyed' do
  fixtures :requirements, :recipes, :ingredients
  
  before(:each) do
    @requirement = requirements(:pizza_water)
    @ingredient = @requirement.ingredient
  end
  
  it 'should decrement requirements_count usages' do
    old_count = @ingredient.requirements_count
    @requirement.destroy
    @ingredient.reload.requirements_count.should == old_count - 1
  end
end