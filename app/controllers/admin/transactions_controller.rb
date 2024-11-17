class Admin::TransactionsController < ApplicationController
  before_action :authenticate_user!, :is_admin?

  def index
    @transactions = transactions.all
  end

  def show
  end

  def edit

  end

  def update

  end

  def create

  end

  def destroy
    
  end
end
