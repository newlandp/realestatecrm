class ContactsController < ApplicationController
    before_action :authenticate_user!
    before_action :require_correct_user
    
    def import
        Contact.import(params[:file], current_user.id)
        redirect_to user_contacts_path(@user), notice: "Contacts imported."
    end
    
    def index
        get_user
        @contacts = @user.contacts.order(:name)
        
        respond_to do |format|
            format.html
            format.csv { send_data @contacts.to_csv }
            format.xls # { send_data @products.to_csv(col_sep: "\t") }
        end
    end
    
    def show
        get_user
        get_contact(@user)
    end
    
    def edit
        get_user
        get_contact(@user)
    end
    
    def update
        get_user
        get_contact(@user)
        
        if @contact.update(contact_params)
            redirect_to user_contact_path(@user.id, @contact.id), notice: "#{@contact.name} Successfully updated!"
        else
            render :edit
        end
    end
    
    def reset
        get_user
        get_contact(@user)
        
        if @contact.status == "orange"
            @user.points += 3
            @user.save
        else
            @user.points += 1
            @user.save
        end
        
        @contact.last_contacted = Time.now
        
        beginning_days_update(@contact)
        
        if @contact.save
            redirect_to user_path(@user.id), notice: "Task successfully completed!"
        else
            render :show, alert: "Oops, something went wrong!"
        end
    end
    
    def new
        get_user
        @contact = @user.contacts.new
    end
    
    def create
        get_user
        @contact = @user.contacts.new(contact_params)
        @contact.last_contacted = Time.now
        
        #make it so prior_relationship doesnt only go to true or nil
        if @contact.prior_relationship
            @contact.beginning_days_between = 365
        else
            @contact.beginning_days_between = 4
        end
        
        if @contact.days_between_contact == 0 || @contact.days_between_contact == nil
            @contact.days_between_contact = 60
        end
        
        if @contact.save
            redirect_to user_contact_path(@user.id, @contact.id), notice: "#{@contact.name} successfully added!"
        else
            render :new
        end
    end
    
    def destroy
        get_user
        get_contact(@user)
        name = @contact.name
        @contact.destroy
        redirect_to user_contacts_url(@user.id), alert: "#{name} successfully deleted!"
    end
    
private
    
    def get_user
        @user = User.find params[:user_id]
    end
    
    def get_contact(user)
        @contact = user.contacts.find params[:id]
    end
    
    def contact_params
        params.require(:contact).permit(:name, :email, :description, :phone_number, :address, :days_between_contact, :last_contacted, :prior_relationship, :interests, :hotlist, :how_we_met)
    end
    
    def require_correct_user
        get_user
        unless current_user == @user
            redirect_to root_url
        end
    end
    
    def beginning_days_update(contact)
        
        # =>    If beginning_days_between is less than days_between_contact than increase 
        # =>    beginning_days_between by certain number of days or by an additional percentage
        # =>    of what it currently is.
        #
        # =>    If days_between_contact is smaller than set beginning_days_between to 365 so that
        # =>    it doesn't come into play again and proceed normally afterwards.
        
        if contact.beginning_days_between
            if contact.beginning_days_between < contact.days_between_contact
                contact.beginning_days_between *= 2
            end
            
            if contact.days_between_contact < contact.beginning_days_between
                contact.beginning_days_between = 365
            end
        end
    end
    
end
