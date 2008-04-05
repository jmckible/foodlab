class CountTagUsage < ActiveRecord::Migration
  def self.up
    add_column :tags, :usages, :integer, :default=>0, :null=>false
  end

  def self.down
    remove_column :tags, :usages
  end
end
