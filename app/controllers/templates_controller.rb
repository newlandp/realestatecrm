class TemplatesController < ApplicationController
    
    before_action :authenticate_user!
    before_action :require_correct_user, except: [:all, :show]
    
    
    def all
        #show all templates of everyone in database
        @templates = Template.all
    end
    
    def index
        #show all templates of current user
        get_user
        @templates = @user.templates
    end
    
    def show
        #show specific template
        get_user
        get_template(@user)
    end
    
    def edit
        get_user
        get_template(@user)
    end
    
    def update
        get_user
        get_template(@user)
        if @template.update(template_params)
            redirect_to user_templates_path(@user.id), notice: "Template successfully updated!"
        else
            render :edit
        end
    end
    
    def new
        get_user
        @template = @user.templates.new
    end
    
    def create
        get_user
        @template = @user.templates.new(template_params)
        if @template.save
            redirect_to user_templates_path(@user.id), notice: "Template successfully created!"
        else
            render :new
        end
    end
    
    def destroy
        get_user
        get_template(@user)
        @template.destroy
        redirect_to user_templates_url(@user.id), alert: "Template successfully deleted!"
    end
    

private
    
    def get_user
        @user = User.find params[:user_id]
    end
    
    def get_template(user)
        @template = user.templates.find params[:id]
    end
    
    def template_params
        params.require(:template).permit(:private, :name, :method_of_communication, :task_description)
    end
    
    def require_correct_user
        get_user
        unless current_user == @user
            redirect_to root_url
        end
    end
    
end
