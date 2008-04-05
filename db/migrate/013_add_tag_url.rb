class AddTagUrl < ActiveRecord::Migration
  def self.up
    add_column :tags, :url, :string
    add_index  :tags, :url
    for tag in Tag.find(:all)
      tag.valid?
      tag.save    
    end
  end

  def self.down
    remove_column :tags, :url
  end
end
