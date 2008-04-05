# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def editable_recipe?
    logged_in? && (current_user.administrator? || @recipe.user == current_user)
  end
  
  def is_administrator?
    logged_in? && current_user.administrator?
  end
  
  def comma_deliminate(objects)
    objects.collect(&:name).join(', ')
  end
  
  def link_list(objects)
    objects.collect{|o| link_to o.name, o, :class=>:tag}.join(', ') 
  end 
  
  def ingredient_cloud(ingredients)
    link_cloud ingredients, :requirements_count
  end
  
  def tag_cloud(tags)
    link_cloud tags, :taggings_count
  end
  
  def link_cloud(objects, count)
    step = (objects.first.send(count) - objects.last.send(count)) / 3
    one = step + objects.last.send(count)
    two = one + step
    
    objects.sort_by(&:name).collect {|object|
      
      wrap = 'tag '
      if object.send(count) <= one
        wrap += 'one'
      elsif object.send(count) <= two
        wrap += 'two'
      else
        wrap += 'three'
      end
      
      link_to object.name, object, :class=>wrap
    }.join('&nbsp;&nbsp; ')
  end
  
end
