class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :user_id, :recipe_id
      t.text :body
      t.timestamps 
    end
    add_index :comments, :user_id
    add_index :comments, :recipe_id
  end

  def self.down
    drop_table :comments
  end
end
