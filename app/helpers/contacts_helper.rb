module ContactsHelper
    
    def contact_status(contact)
        
        str = ""
        
        if contact.status == "red"
            str = '<i class="fa fa-circle" style="color:red;padding-left:10px;"></i>'.html_safe
        elsif contact.status == "orange"
            str = '<i class="fa fa-circle" style="color:orange;padding-left:10px;"></i>'.html_safe
        else
            str = '<i class="fa fa-circle" style="color:green;padding-left:10px;"></i>'.html_safe
        end
        
        str
    end
    
    def days_status(contact)
        
        str = ""
        
        if contact.days_from_task_date > 0
            str = "Past Due"
        elsif contact.days_from_task_date == 0
            str = "Due Today"
        else
            str = "#{pluralize((contact.days_from_task_date * -1), "Day")} Until Due"
        end
        
        str
    end
    
end
