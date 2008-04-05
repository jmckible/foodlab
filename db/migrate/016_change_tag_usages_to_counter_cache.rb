class ChangeTagUsagesToCounterCache < ActiveRecord::Migration
  def self.up
    rename_column :tags, :usages, :taggings_count
  end

  def self.down
    rename_column :tags, :taggings_count, :usages
  end
end
