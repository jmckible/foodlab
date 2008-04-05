require File.dirname(__FILE__) + '/../spec_helper'

describe Tag, 'the class' do
  fixtures :tags
  
  it 'should find or create by fixed name' do
    Tag.find_or_create_by_name('fast').should == tags(:fast)
    Tag.find_or_create_by_name(' FAST ').should == tags(:fast)
  end
  
  it 'should find popular with at least 1 useage' do
    Tag.popular.should == tags(:fast, :baking)
  end
end

describe Tag, 'valid and saved' do
  fixtures :tags, :taggings, :recipes
  
  before(:each) do
    @tag = tags(:fast)
  end
  
  it 'should have taggings' do
    @tag.taggings.should == taggings(:pizza_fast_jordan, :pizza_fast_dave, :herring_fast_jordan)
  end
  
  it 'should have recipes sorted by rating then name' do
    @tag.recipes.should == recipes(:pizza, :herring)
  end
  
  it 'should use url as to_param' do
    @tag.to_param.should == @tag.url
  end
end

describe Tag, 'new' do
  fixtures :tags
  
  before(:each) do
    @tag = Tag.new
  end

  it 'should be not valid' do
    @tag.should_not be_valid
  end
  
  it 'should have a name' do
    @tag.should have(1).error_on(:name)
  end
  
  it 'should have a url' do
    @tag.should have(1).error_on(:url)
  end
  
  it 'should strip spaces before validation' do
    @tag.name = ' spaces  '
    @tag.should be_valid
    @tag.name.should == 'spaces'
  end
  
  it 'should downcase everything' do
    @tag.name = 'YELLING'
    @tag.should be_valid
    @tag.name.should == 'yelling'
  end
  
  it 'should generate url' do
    @tag.name = 'super awesome'
    @tag.should be_valid
    @tag.url.should == 'super-awesome' 
  end
end

describe Tag, 'clone' do
  fixtures :tags
  
  before(:each) do
    @tag = tags(:fast).clone
  end
  
  it 'should not be valid' do
    @tag.should_not be_valid
  end
  
  it 'should have a unique name' do
    @tag.should have(1).error_on(:name)
  end
  
  it 'should have a unique url' do
    @tag.should have(1).error_on(:url)
  end
  
  it 'should have a unique name by case' do
    @tag.name.swapcase!
    @tag.should_not be_valid
    @tag.should have(1).error_on(:name)
  end
end
