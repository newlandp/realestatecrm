class ChangePhoneNumber < ActiveRecord::Migration
  def change
    change_column :contacts, :phone_number, :integer, limit: 32
  end
end
