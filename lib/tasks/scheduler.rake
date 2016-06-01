namespace :scheduler do
  desc "rake task to update the user tasks (heroku)"
  task update_user_tasks_heroku: :environment do
    User.update_user_tasks
    puts "Updated user tasks at #{Time.now} - Success!"
  end
end