class ChangeNameAndTaskDescriptionFields < ActiveRecord::Migration
  def change
    change_column :templates, :name, :string, :default => nil
    change_column :templates, :task_description, :text, :default => nil
  end
end
