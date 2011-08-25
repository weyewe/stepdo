class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  helper_method :user_session 
  
  private
  def after_sign_in_path_for(resource)
      posts_url
  end
end
