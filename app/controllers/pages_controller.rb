class PagesController < ApplicationController
    
    before_action :authenticate_user!, :except => [:landing]
    before_action :require_subscription, :except => [:landing]
    
    def profile
        @user = current_user
    end
    
    def bootstrap_elements
    end
    
    def blank_page
    end
    
    def bootstrap_grid
    end
    
    def forms
    end
    
    def index
    end
    
    def tables
    end
    
    def landing
        render :layout => "landing"
    end
    
    def charts
    end
    
    def about
    end
    
    def import_contacts
        @user = current_user
        @contacts = @user.contacts.order(:name)
        
        respond_to do |format|
            format.html
            format.csv { send_data @contacts.to_csv }
            format.xls # { send_data @products.to_csv(col_sep: "\t") }
        end
    end
end
