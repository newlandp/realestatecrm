module PagesHelper
    
    def contact_status_color(contact)
        
        str = ""
        
        if contact.status == "red"
            str = '<i class="fa fa-circle" style="color:red;padding-top:8px"></i>'.html_safe
        elsif contact.status == "orange"
            str = '<i class="fa fa-circle" style="color:orange;padding-top:8px"></i>'.html_safe
        else
            str = '<i class="fa fa-circle" style="color:green;padding-top:8px"></i>'.html_safe
        end
        
        str
    end
    
    def contacts_by_days_since_task_date_with_limit(user)
        user.contacts_by_days_since_task_date[0..3]
    end
    
end
