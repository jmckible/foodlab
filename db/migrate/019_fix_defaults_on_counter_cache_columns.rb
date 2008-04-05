class FixDefaultsOnCounterCacheColumns < ActiveRecord::Migration
  def self.up
    change_column :tags, :taggings_count, :integer, :default=>0, :null=>false
    change_column :ingredients, :requirements_count, :integer, :default=>0, :null=>false
  end

  def self.down
  end
end
