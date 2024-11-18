class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def active_for_authentication?
    super && account_status == 'approved'
  end

  def inactive_message
    account_status == 'pending' ? :pending_approval : super
  end

  after_create :set_pending_status_and_notify

  private

  def set_pending_status_and_notify
    update_column(:account_status, 'pending')
    UserMailer.registration_pending(self).deliver_now
  end
end
