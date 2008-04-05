class Tagging < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :tag, :counter_cache=>true
  belongs_to :user
  
  after_create  :bookmark_recipe
  
  validates_presence_of :recipe, :tag, :user
  validates_uniqueness_of :tag_id, :scope=>[:recipe_id, :user_id]
  
  protected  
  def bookmark_recipe
    existing = Bookmark.find :first, :conditions=>{:user_id=>user.id, :recipe_id=>recipe.id}
    Bookmark.create :user=>user, :recipe=>recipe if existing.nil?
  end
end
