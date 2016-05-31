class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name, :default => ""
      t.text :task_description, :default => ""
      t.boolean :private, :default => true
      t.string :method_of_communication, :default => ""

      t.timestamps
    end
  end
end
