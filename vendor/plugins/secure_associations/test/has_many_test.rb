require File.join(File.dirname(__FILE__), 'test_helper')

class HasManyTest < Test::Unit::TestCase
  fixtures :users, :widgets

  def test_cannot_make_new_with_widget_ids
    user = User.new(:name=>'Charlie', :widget_ids=>[widgets(:foo).id, widgets(:bar).id])
    assert_equal 'Charlie', user.name
    assert_equal [], user.widgets
    assert_equal [], user.widget_ids
  end
  
  def test_cannot_make_new_with_widgets
    user = User.new(:name=>'Charlie', :widgets=>[widgets(:foo)])
    assert_equal 'Charlie', user.name
    assert_equal [], user.widgets
    assert_equal [], user.widget_ids
  end
  
  def test_cannot_create_with_widget_ids
    user = User.create!(:name=>'Charlie', :widget_ids=>[widgets(:foo).id, widgets(:bar).id])
    assert_equal 'Charlie', user.name
    assert_equal [], user.widgets
    assert_equal [], user.widget_ids
  end
  
  def test_cannot_create_with_widgets
    user = User.create!(:name=>'Charlie', :widgets=>[widgets(:foo)])
    assert_equal 'Charlie', user.name
    assert_equal [], user.widgets
    assert_equal [], user.widget_ids
  end
  
  def test_cannot_update_widget_ids_with_update_attributes
    user = users(:alice)
    user.update_attributes!(:name=>'Charlie', :widget_ids=>[widgets(:bar).id])
    assert_equal 'Charlie', user.name
    assert_equal [widgets(:foo).id], user.widget_ids
    assert_equal [widgets(:foo)], user.widgets
  end
  
  def test_cannot_update_widget_ids_with_update_attributes
    user = users(:alice)
    user.update_attributes!(:name=>'Charlie', :widgets=>[widgets(:bar)])
    assert_equal 'Charlie', user.name
    assert_equal [widgets(:foo).id], user.widget_ids
    assert_equal [widgets(:foo)], user.widgets
  end
  
end
