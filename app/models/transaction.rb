class Transaction < ApplicationRecord
  belongs_to :user

  def is_approved?
    account_status == 'approved'
  end

end
