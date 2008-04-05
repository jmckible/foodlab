require File.dirname(__FILE__) + '/../spec_helper'

###################################
#           C L A S S             #
###################################
describe Recipe, 'the class' do
  fixtures :recipes
  
  it 'should find newest' do
    Recipe.newest.should == recipes(:herring, :pizza)
  end
  
  it 'should have top' do
    Recipe.top.should == recipes(:pizza, :herring)
  end
  
  it 'should clean params hash' do
    update_hash = {
      '0'=>{'name'=>'water', 'quantity'=>'1'}, 
      '1'=>{'name'=>'flour', 'quantity'=>'2'}
    }
    Recipe.clean_requirements_hash(update_hash).should == [{:name=>'water', :quantity=>'1'}, {:name=>'flour', :quantity=>'2'}]
  end
  
  it 'should clean params hash with all blank' do
    update_hash = {
      '0'=>{'name'=>nil, 'quantity'=>nil}, 
      '1'=>{'name'=>'', 'quantity'=>'2'}
    }
    Recipe.clean_requirements_hash(update_hash).should == []
  end
  
  it 'should use acts_as_ferret' do
    Recipe.should respond_to(:find_by_contents)
  end
end

describe Recipe, 'valid and saved' do
  fixtures :recipes, :users, :requirements, :ingredients, :tags, :taggings, :ratings, :comments
  
  before(:each) do
    @recipe = recipes(:pizza)
  end
  
  it 'should act as textiled' do
    @recipe.should respond_to(:textiled)
  end
  
  it 'should have a nice looking slug' do
    @recipe.to_param.should == '1-pizza'
  end
  
  it 'should list tags & ingredients for indexing' do
    @recipe.tag_list.should == 'fast baking' 
    @recipe.ingredients_list.should == 'water flour' 
  end
  
  it 'should have a created at integer for sorting in Ferret' do
    @recipe.created_at_sort.should be_is_a(Integer) #be_an_instance_of did not work 
  end
  
  it 'should have an author name for Ferret index' do
    @recipe.author_name.should == 'Jordan McKible'
  end
  
  ###################################
  #    R E L A T I O N S H I P S    #
  ###################################
  it 'should belong to a user' do
    @recipe.user.should == users(:jordan)
  end
  
  it 'should have many comments' do
    @recipe.comments.should == comments(:jordan_pizza, :dave_pizza)
  end
  
  it 'should have many ratings' do
    @recipe.ratings.should == [ratings(:jordan_pizza)]
  end
  
  it 'should update the rating' do
    @recipe.update_rating!
    @recipe.rating.should == 5
  end
  
  it 'should have many requirements' do
    @recipe.requirements.should == requirements(:pizza_water, :pizza_flour)
  end
  
  it 'should have many ingredients' do
    @recipe.ingredients.should == ingredients(:water, :flour)
  end
  
  it 'should have many taggings' do
    @recipe.taggings.should == taggings(:pizza_baking_jordan, :pizza_fast_jordan, :pizza_fast_dave)
  end
  
  it 'should have many tags' do
    @recipe.tags.should == tags(:fast, :baking)
    @recipe.tags.top.should == [tags(:fast)]
    @recipe.tags.from(users(:jordan)).should == tags(:baking, :fast)
  end
  
  it 'should update user tags' do
    @recipe.update_user_tags! users(:jordan), 'grill, bake, stretch'
    @recipe.reload.tags.from(users(:jordan)).collect(&:name).should == %w(grill bake stretch)
  end
  
  it 'should add user tags' do
    @recipe.add_user_tags! users(:jordan), 'delicious'
    @recipe.reload.tags.from(users(:jordan)).collect(&:name).should == %w(baking fast delicious)
  end
  
  ###################################
  #    R E Q U I R E M E N T S      #
  ###################################
  it 'should update requirements with same number' do
    # change one ingredient's quantity, and one's name
    update_hash = {
      0=>{:name=>requirements(:pizza_water).ingredient.name, :quantity=>'16 oz'}, 
      1=>{:name=>'bread flour', :quantity=>requirements(:pizza_flour).quantity}
    }
    old_water_quantity = requirements(:pizza_water).quantity
    lambda { 
      @recipe.update_requirements!(update_hash).size.should == 2
    }.should change(Ingredient, :count)
    requirements(:pizza_water).reload.quantity.should_not == old_water_quantity
  end
  
  it 'should update requirements with fewer' do
    update_hash = {
      0=>{:name=>requirements(:pizza_water).ingredient.name, :quantity=>'16 oz'}
    }
    old_water_quantity = requirements(:pizza_water).quantity
    @recipe.update_requirements!(update_hash).size.should == 1
    requirements(:pizza_water).reload.quantity.should_not == old_water_quantity
  end
  
  it 'should update requirements with more' do
    # change one ingredient's quantity, and one's name
    update_hash = {
      0=>{:name=>requirements(:pizza_water).ingredient.name, :quantity=>'16 oz'}, 
      1=>{:name=>'bread flour', :quantity=>requirements(:pizza_flour).quantity},
      2=>{:name=>'yeast', :quantity=>'one packet'}
    }
    old_water_quantity = requirements(:pizza_water).quantity
    lambda { 
      @recipe.update_requirements!(update_hash).size.should == 3
    }.should change(Ingredient, :count)
    requirements(:pizza_water).reload.quantity.should_not == old_water_quantity
  end
  
  it 'should update requirements with blank' do
    update_hash = {
      0=>{:name=>nil, :quantity=>nil}, 
      1=>{:name=>'', :quantity=>'1 lb'}
    }
    @recipe.update_requirements!(update_hash).size.should == 0
    lambda { requirements(:pizza_water) }.should raise_error(ActiveRecord::RecordNotFound)
    lambda { requirements(:pizza_flour) }.should raise_error(ActiveRecord::RecordNotFound)
  end
  
  ###################################
  #      P R O T E C T I O N        #
  ###################################
  it 'should not update user through mass assignment' do
    @recipe.update_attributes! :user=>users(:dave)
    @recipe.reload.user.should == users(:jordan)
  end
  
  it 'should not update requirements through mass assignment' do
    @recipe.update_attributes! :requirements=>[requirements(:herring_herring)]
    @recipe.requirements.should == requirements(:pizza_water, :pizza_flour)
  end
  
  it 'should not update timestamps through mass assignment' do
    @recipe.update_attributes! :created_at=>1.year.from_now, :updated_at=>1.year.from_now
    @recipe.created_at.should <= Time.now
    @recipe.updated_at.should <= Time.now
  end
end

describe Recipe, 'new' do
  fixtures :recipes, :users
  
  before(:each) do
    @recipe = Recipe.new
  end
  
  def make_valid_and_save
    @recipe.name = 'New'
    @recipe.process = 'make it'
    @recipe.user = users(:jordan)
    @recipe.should be_valid
    @recipe.save
  end

  it 'should not be valid' do
    @recipe.should_not be_valid
  end
  
  it 'should have a name' do
    @recipe.should have(1).error_on(:name)
  end
  
  it 'should have a process' do
    @recipe.should have(1).error_on(:process)
  end
  
  it 'should belong to a user' do
    @recipe.should have(1).error_on(:user)
  end
  
  it 'should create requirements' do
    make_valid_and_save
    create_hash = {
      0=>{:name=>'water', :quantity=>'16 oz'}, 
      1=>{:name=>'flour', :quantity=>'3 cups'},
      2=>{:name=>'yeast', :quantity=>'one packet'}
    }
    lambda {
      @recipe.create_requirements! create_hash
    }.should change(Requirement, :count)
    @recipe.requirements.size.should == 3
  end
  
  it 'should create requirements with misordered, string keys'  do
    make_valid_and_save
    create_hash = {
      '10'=>{:name=>'water', :quantity=>'16 oz'}, 
      '2'=>{:name=>'flour', :quantity=>'3 cups'}
    }
    lambda {
      @recipe.create_requirements! create_hash
    }.should change(Requirement, :count)
    @recipe.requirements.collect(&:name).should == ['flour', 'water']
  end

end
