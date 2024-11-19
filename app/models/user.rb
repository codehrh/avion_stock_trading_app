class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  # has_many: stocks, dependent: :delete_all
  # has_many: transactions, dependent: :delete_all

  # def active_for_authentication?
  #   super && account_status == 'approved'
  # end

  after_create :set_pending_status_and_notify

  private

  def set_pending_status_and_notify
    update_column(:account_status, 'pending')
    UserMailer.registration_pending(self).deliver_now
  end
end
