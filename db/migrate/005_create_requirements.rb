class CreateRequirements < ActiveRecord::Migration
  def self.up
    create_table :requirements do |t|
      t.timestamps 
      t.integer :recipe_id, :ingredient_id, :position
      t.string  :quantity 
    end
    add_index :requirements, :recipe_id
    add_index :requirements, :ingredient_id
  end

  def self.down
    drop_table :requirements
  end
end
