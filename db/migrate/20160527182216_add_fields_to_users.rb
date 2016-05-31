class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :points, :integer, :default => 0
    add_column :users, :max_contacts_per_day, :integer, :default => 5
  end
end
