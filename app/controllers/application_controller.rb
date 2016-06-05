class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }
  
  layout :layout_by_resource

  protected

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end
  
private
  
  def require_subscription
      unless current_user.subscribed == true
          redirect_to new_subscriber_path
      end
  end
  
end
