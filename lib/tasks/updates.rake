namespace :updates do
  desc "rake task to update the user tasks"
  task update_user_tasks: :environment do
    User.update_user_tasks
    puts "Updated user tasks at #{Time.now} - Success!"
  end
end
