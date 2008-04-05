class CreateRecipes < ActiveRecord::Migration
  def self.up
    create_table :recipes do |t|
      t.timestamps 
      t.integer :user_id
      t.string  :name
      t.text    :process
    end
    add_index :recipes, :user_id
  end

  def self.down
    drop_table :recipes
  end
end
