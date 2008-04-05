class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.timestamps 
      t.string :first_name, :last_name, :email
      t.string :password_hash, :password_salt
    end
    add_index :users, :email
  end

  def self.down
    drop_table :users
  end
end
