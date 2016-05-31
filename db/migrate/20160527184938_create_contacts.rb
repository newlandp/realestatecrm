class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name, :default => ""
      t.string :email, :default => ""
      t.integer :phone_number
      t.string :address, :default => ""
      t.integer :days_between_contact, :default => 50
      t.datetime :last_contacted
      t.integer :beginning_days_between
      t.boolean :prior_relationship, :default => false
      t.text :interests, :default => ""
      t.text :how_we_met, :default => ""
      t.text :notes, :default => ""
      t.boolean :hotlist, :default => false

      t.timestamps
    end
  end
end
