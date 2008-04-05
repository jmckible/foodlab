class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.timestamps 
      t.integer :user_id, :recipe_id
      t.integer :value, :default=>0, :null=>false
    end
    add_index :ratings, :user_id
    add_index :ratings, :recipe_id
    
    add_column :recipes, :rating, :decimal, :precision=>3, :scale=>2, :null=>false, :default=>0
  end

  def self.down
    drop_table :ratings
    remove_column :recipes, :rating
  end
end
