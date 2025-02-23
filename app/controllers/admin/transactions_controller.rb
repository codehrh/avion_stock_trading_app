class Admin::TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @q = Transaction.ransack(params[:q])
    @transactions = @q.result(distinct: true)
  end

end
