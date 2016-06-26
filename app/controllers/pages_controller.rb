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
end
