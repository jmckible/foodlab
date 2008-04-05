class AddPasswordResetToken < ActiveRecord::Migration
  def self.up
    add_column :users, :password_reset_token, :string
  end

  def self.down
    remove_column :users, :password_reset_token
  end
end
