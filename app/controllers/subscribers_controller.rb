class SubscribersController < ApplicationController
    before_filter :authenticate_user!
    layout "stripe"
    
    def new
    end
    
    def update
        token = params[:stripeToken]

        #create a customer
        customer = Stripe::Customer.create(
            card: token,
            plan: 206,
            email: current_user.email
        )
    
        current_user.subscribed = true
        current_user.stripeid = customer.id
        current_user.save
    
    
        redirect_to home_path, notice: "Your subscription was set up successfully! #{token}"
    end
    
end
