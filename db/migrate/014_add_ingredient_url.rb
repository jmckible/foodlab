class AddIngredientUrl < ActiveRecord::Migration
  def self.up
    add_column :ingredients, :url, :string
    add_index  :ingredients, :url
    for i in Ingredient.find(:all)
      i.valid?
      i.save    
    end
  end

  def self.down
    remove_column :ingredients, :url
  end
end
