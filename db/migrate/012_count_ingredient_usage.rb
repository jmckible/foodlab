class CountIngredientUsage < ActiveRecord::Migration
  def self.up
    add_column :ingredients, :usages, :integer, :default=>0, :null=>false
  end

  def self.down
    remove_column :ingredients, :usages
  end
end
