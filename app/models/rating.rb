class Rating < ActiveRecord::Base
  OPTIONS = %w(Terrible Edible Average Good Excellent)
  
  belongs_to :recipe, :protected=>true
  belongs_to :user, :protected=>true
  
  after_save :update_recipe_rating
  
  validates_presence_of :value, :recipe, :user
  validates_numericality_of :value, :only_integer=>true
  
  protected
  def validate
    errors.add(:value, 'must be from 1-5') if !value.nil? && (value < 1 or value > Rating::OPTIONS.size)
  end
  
  def update_recipe_rating
    recipe.update_rating!
  end
end
