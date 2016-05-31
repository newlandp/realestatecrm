class ChangeUserTasks < ActiveRecord::Migration
  def change
    change_column :users, :user_tasks, :string, :default => ""
  end
end
