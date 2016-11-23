class UsersController < ApplicationController
    def edit
        get_user
    end
    
    def update
        get_user
        
        if @user.update(user_params)
            redirect_to home_path, notice: "Successfully updated!"
        else
            render :edit
        end
    end
    
private
    def get_user
        @user = User.find params[:id]
    end
    
    def user_params
        params.require(:user).permit(:max_contacts_per_day)
    end
    
end