class Admin::UsersController < ApplicationController

  def index
    @users = User.all.order(id: :asc) #unused
    @approved_users = User.where(account_status: 'approved', admin: false).order(id: :asc)
    @pending_users = User.where(account_status: 'pending', admin: false).order(id: :asc)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    
    if @user.update(user_params)
      redirect_to admin_user_path
    else 
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to admin_users_path, status: :see_other
  end
  
  def approve
    @user = User.find(params[:id])
    if @user.update(account_status: 'approved')
      UserMailer.account_approved(@user).deliver_now
      redirect_to admin_users_path, notice: "User has been approved."
    else
      redirect_to admin_users_path, alert: "Error occurred with approval."
    end
  end

  def deny
    @user = User.find(params[:id])
    if @user.destroy
      UserMailer.account_denied(@user).deliver_now
      redirect_to admin_users_path, notice: "User has been denied."
    else
      redirect_to admin_users_path, alert: "Error occured with denial."
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :balance, :password, :password_confirmation)
    end
end
