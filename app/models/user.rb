class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  validates :max_contacts_per_day, numericality: { greater_than: 0 }
  
  has_many :contacts, dependent: :destroy
  has_many :templates, dependent: :destroy
  
  def contacts_for_today
    todays_contacts = []
    self.contacts.each do |contact|
      
      if contact.beginning_days_between
        if contact.beginning_days_between < contact.days_between_contact
          if contact.days_since == contact.beginning_days_between
            todays_contacts << contact
          end
        end
        
        if contact.days_between_contact <= contact.beginning_days_between
          if contact.days_since == contact.days_between_contact
            todays_contacts << contact
          end
        end
      else
        if contact.days_since == contact.days_between_contact
          todays_contacts << contact
        end
      end
      
    end
    
    todays_contacts = self.late_contacts.sort { |a, b| b.days_since <=> a.days_since } + todays_contacts.sort { |a, b| b.days_since <=> a.days_since }
    
    if self.max_contacts_per_day
      todays_contacts[0..(self.max_contacts_per_day - 1)]
    end
    
  end
  
  
  
  def late_contacts
    #same as contacts_for_today, but make some sort of formula for how late contacts show up in task list
    #after this method is finished, add list to contacts_for_today
    
    todays_contacts = []
    self.contacts.each do |contact|
      
      if contact.beginning_days_between
        
        if contact.beginning_days_between < contact.days_between_contact
          if contact.days_since > contact.beginning_days_between
            todays_contacts << contact if contact.days_since - contact.beginning_days_between == 1
            todays_contacts << contact if contact.days_since - contact.beginning_days_between == 2
            todays_contacts << contact if contact.days_since - contact.beginning_days_between == 4
            todays_contacts << contact if contact.days_since - contact.beginning_days_between == 8
            todays_contacts << contact if (contact.days_since - contact.beginning_days_between) / 14.0 == 0.0
          end
        end
        
        if contact.days_between_contact <= contact.beginning_days_between
          if contact.days_since > contact.days_between_contact
            todays_contacts << contact if contact.days_since - contact.days_between_contact == 1
            todays_contacts << contact if contact.days_since - contact.days_between_contact == 2
            todays_contacts << contact if contact.days_since - contact.days_between_contact == 4
            todays_contacts << contact if contact.days_since - contact.days_between_contact == 8
            todays_contacts << contact if (contact.days_since - contact.days_between_contact) / 14.0 == 0.0
          end
        end
        
      else
        
        if contact.days_since > contact.days_between_contact
            todays_contacts << contact if contact.days_since - contact.days_between_contact == 1
            todays_contacts << contact if contact.days_since - contact.days_between_contact == 2
            todays_contacts << contact if contact.days_since - contact.days_between_contact == 4
            todays_contacts << contact if contact.days_since - contact.days_between_contact == 8
            todays_contacts << contact if (contact.days_since - contact.days_between_contact) / 14.0 == 0.0
        end
        
      end
      
    end
    
    todays_contacts
    
  end
  
  def contacts_by_days_since_task_date
    
    contacts = self.contacts
    
    contacts.sort { |a, b| b.days_from_task_date <=> a.days_from_task_date }
    
  end
  
  def self.update_user_tasks
    User.all.each do |user|
      tasks = ""
      
      user.contacts_for_today.each do |contact|
        tasks = tasks + contact.id.to_s
        tasks = tasks + " "
      end
      
      if tasks == "" && user.contacts_by_days_since_task_date[0]
        tasks = tasks + user.contacts_by_days_since_task_date[0].id.to_s if user.contacts_by_days_since_task_date[0].status == "red"
      end
      
      user.user_tasks = tasks.rstrip
      user.save
    end
  end
  
  def user_tasks_array
    contacts = []
    array = self.user_tasks.split(" ").map(&:to_i)
    array.each do |i|
      contacts << self.contacts.find(i)
    end
    contacts
  end
  
  def number_of_tasks_completed
    total = 0
    self.user_tasks_array.each do |contact|
      total += 1 if contact.status == "green"
    end
    total
  end
  
  def number_of_tasks_remaining
    self.user_tasks_array.size - self.number_of_tasks_completed
  end
  
  def percent_of_tasks_completed
    ((self.number_of_tasks_completed.to_f / self.user_tasks_array.size.to_f).round(3) * 100).round
  end
  
  
end
