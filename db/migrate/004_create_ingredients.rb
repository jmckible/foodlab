class CreateIngredients < ActiveRecord::Migration
  def self.up
    create_table :ingredients do |t|
      t.timestamps 
      t.string :name
    end
    add_index :ingredients, :name
  end

  def self.down
    drop_table :ingredients
  end
end
