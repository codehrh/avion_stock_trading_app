class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # before_action :configure_permitted_parameters, if: :devise_controller?



  allow_browser versions: :modern
end
