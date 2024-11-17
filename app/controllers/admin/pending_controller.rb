class Admin::PendingController < ApplicationController

  def index
    
  end

  private
  def user_params
    params.require(:user).permit(:role, :account_status)
  end
end
