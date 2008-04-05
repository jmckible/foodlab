class AddTaggingIndexes < ActiveRecord::Migration
  def self.up
    add_index :tags, :name
    add_index :taggings, :tag_id
    add_index :taggings, :recipe_id
    add_index :taggings, :user_id
  end

  def self.down
    remove_index :tags, :name
    remove_index :taggings, :tag_id
    remove_index :taggings, :recipe_id
    remove_index :taggings, :user_id
  end
end
