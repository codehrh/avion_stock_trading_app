class TransactionsController < ApplicationController
  before_action :authenticate_user!, :is_approved?

  def index
  end
  
end
