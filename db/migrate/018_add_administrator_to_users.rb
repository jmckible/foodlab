class AddAdministratorToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :administrator, :boolean, :null=>false, :default=>false
    admin = User.find 1
    admin.administrator = true
    admin.save
  end

  def self.down
    remove_column :users, :administrator
  end
end
