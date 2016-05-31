class Contact < ActiveRecord::Base
    belongs_to :user
  
    validates :name, presence: true
    validates :email, presence: true, format: /\A\S+@\S+\z/
    validates :days_between_contact, numericality: { greater_than: 0 }
    validates :phone_number, numericality: { only_integer: true }
    
    def days_since_created
        (((self.created_at-Time.now)/86400).to_i) * -1
    end
    
    def days_since
        #if self.days_since_created < (self.days_between_contact || self.beginning_days_between)
        #    self.days_since_created
        #else
            (((self.last_contacted-Time.now)/86400).to_i) * -1
        #end
    end
    
    def status
        
        status = ""
        
        if self.beginning_days_between
            if self.beginning_days_between < self.days_between_contact
                if self.days_since == self.beginning_days_between
                    status = "orange"
                elsif self.days_since > self.beginning_days_between
                    status = "red"
                else
                    status = "green"
                end
            end
            if self.days_between_contact <= self.beginning_days_between
                if self.days_since == self.days_between_contact
                    status = "orange"
                elsif self.days_since > self.days_between_contact
                    status = "red"
                else
                    status = "green"
                end
            end
        else
            if self.days_since == self.days_between_contact
                status = "orange"
            elsif self.days_since > self.days_between_contact
                status = "red"
            else
                status = "green"
            end
        end
        
        status
        
    end
    
    def days_from_task_date
        
        number = 0
        
        if self.beginning_days_between
            if self.beginning_days_between < self.days_between_contact
                number = self.days_since - self.beginning_days_between
            end
            if self.days_between_contact <= self.beginning_days_between
                number = self.days_since - self.days_between_contact
            end
        else
            number = self.days_since - self.days_between_contact
        end
        
        number
        
    end
    
    
    #working well, nothing to change
    def self.to_csv(options = {})
        CSV.generate(options) do |csv|
            csv << column_names
            all.each do |contact|
                csv << contact.attributes.values_at(*column_names)
            end
        end
    end
    
    #working on ***IMPORT***
    def self.import(file, current_user_id)
        
        #edit attributes
        accessible_attributes = "name", "email", "days_between_contact", "phone_number", "notes", "address", "interests", "hotlist", "how_we_met", "created_at"
        
        CSV.foreach(file.path, headers: true) do |row|
            contact = find_by_id(row["id"]) || new
            #if non-new contact (one that has an ID already) has a created_at value that DOES NOT match the one for that contact that is already in the database, then skip over making changes or doing anything with
            #this contact (next keyword)
            
            #if contact is not new then get its created_at value that already exists in database and store in variable (created_at_original)
            if contact.new_record? != true
                created_at_original = contact.created_at
            end
            
            contact.attributes = row.to_hash.slice(*accessible_attributes)
            
            #if contact is not new and created_at_original != contact.created_at then do not save this contact and skip to next iteration (next keyword)
            if contact.new_record? != true
                if created_at_original != contact.created_at
                    next
                end
            end
            
            contact.user_id = current_user_id
            
            if contact.days_between_contact == 0 || contact.days_between_contact == nil || contact.days_between_contact == ""
                contact.days_between_contact = 60
            end
            
            if contact.new_record?
                contact.last_contacted = Time.now - Random.rand(1...contact.days_between_contact).day
                contact.prior_relationship = true
                contact.beginning_days_between = 365
            end
            
            if contact.hotlist != true && contact.hotlist != false
                contact.hotlist = false
            end
            
            if contact.name == 0 || contact.name == nil || contact.name == ""
                contact.name = "Unnamed Contact"
            end
            
            if contact.email == 0 || contact.email == nil || contact.email == ""
                contact.email = "placeholder.email@example.com"
            end
            
            if contact.phone_number == 0 || contact.phone_number == nil || contact.phone_number == ""
                contact.phone_number = 5555555555
            end
            
            contact.save!
        end
    
    end
end
