class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  def authenticate_user!
    unless current_user
      redirect_to login_path, alert: "Please login first."
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  helper_method :current_user
end
