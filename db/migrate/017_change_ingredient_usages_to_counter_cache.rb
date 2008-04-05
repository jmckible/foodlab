class ChangeIngredientUsagesToCounterCache < ActiveRecord::Migration
  def self.up
    rename_column :ingredients, :usages, :requirements_count
  end

  def self.down
    rename_column :ingredients, :requirements_count, :usages
  end
end
