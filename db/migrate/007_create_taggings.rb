class CreateTaggings < ActiveRecord::Migration
  def self.up
    create_table :taggings do |t|
      t.timestamps 
      t.integer :tag_id, :recipe_id, :user_id
    end
  end

  def self.down
    drop_table :taggings
  end
end
