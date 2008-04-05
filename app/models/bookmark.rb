class Bookmark < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :user
  
  validates_presence_of :user, :recipe
  validates_uniqueness_of :recipe_id, :scope=>:user_id
end
