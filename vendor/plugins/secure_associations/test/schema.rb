ActiveRecord::Schema.define(:version=>1) do
  create_table :users, :force=>true do |t|
    t.column :name, :string
  end
  
  create_table :widgets, :force=>true do |t|
    t.column :name, :string
    t.column :user_id, :integer
  end

end