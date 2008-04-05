class CreateBookmarks < ActiveRecord::Migration
  def self.up
    create_table :bookmarks do |t|
      t.timestamps 
      t.integer :user_id, :recipe_id
    end
    
    add_index :bookmarks, :user_id
    add_index :bookmarks, :recipe_id
    
    for user in User.find(:all)
      for tagging in user.taggings.find(:all, :order=>:created_at)
        existing = Bookmark.find :first, :conditions=>{:user_id=>user.id, :recipe_id=>tagging.recipe_id}
        Bookmark.create :user_id=>user.id, :recipe_id=>tagging.recipe.id if existing.nil?
      end
    end
  end

  def self.down
    drop_table :bookmarks
  end
end
