class AddUserTasksToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_tasks, :string
  end
end
