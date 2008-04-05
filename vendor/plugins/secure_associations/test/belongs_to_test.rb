require File.join(File.dirname(__FILE__), 'test_helper')

class BelongsToTest < Test::Unit::TestCase
  fixtures :users, :widgets

  def test_cannot_make_new_with_user_id
    widget = Widget.new(:name=>'new', :user_id=>1)
    assert_equal 'new', widget.name
    assert_nil widget.user_id
    assert_nil widget.user
  end
  
  def test_cannot_make_new_with_user
    widget = Widget.new(:name=>'new', :user=>users(:bob))
    assert_equal 'new', widget.name
    assert_nil widget.user_id
    assert_nil widget.user
  end
  
  def test_cannot_create_with_user_id
    widget = Widget.create!(:name=>'new', :user_id=>1)
    assert_equal 'new', widget.name
    assert_nil widget.user_id
    assert_nil widget.user
  end
  
  def test_cannot_create_with_user
    widget = Widget.create!(:name=>'new', :user=>users(:bob))
    assert_equal 'new', widget.name
    assert_nil widget.user_id
    assert_nil widget.user
  end
  
  def test_cannot_build_through_another_user
    widget = users(:bob).widgets.build(:name=>'new', :user=>users(:alice))
    assert_equal 'new', widget.name
    assert users(:bob), widget.user
  end
  
  def test_cannot_build_through_another_user_id
    widget = users(:bob).widgets.build(:name=>'new', :user_id=>users(:alice).id)
    assert_equal 'new', widget.name
    assert users(:bob), widget.user
  end
      
  def test_cannot_update_user_id_with_update_attributes
    widget = widgets(:foo)
    widget.update_attributes!(:name=>'baz', :user_id=>users(:bob))
    assert_equal 'baz', widget.name
    assert_equal users(:alice).id, widget.user_id
    assert_equal users(:alice), widget.user
  end
  
  def test_cannot_update_user_with_update_attributes
    widget = widgets(:foo)
    widget.update_attributes!(:name=>'baz', :user=>users(:alice))
    assert_equal 'baz', widget.name
    assert_equal users(:alice).id, widget.user_id
    assert_equal users(:alice), widget.user
  end

end