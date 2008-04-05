class Requirement < ActiveRecord::Base
  belongs_to :ingredient, :protected=>true, :counter_cache=>true
  belongs_to :recipe, :protected=>true
  
  def name
    ingredient.nil? ? nil : ingredient.name
  end
  def name=(name)
    self.ingredient = Ingredient.find_or_create_by_name(name) unless name.blank?
  end
  
  validates_presence_of :ingredient, :recipe

end
