class Transaction < ApplicationRecord
  belongs_to :user

  def is_approved?
    account_status == 'approved'
  end

  validates :company_name, presence: true
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_price, numericality: { greater_than_or_equal_to: 0 }
  validates :shares, numericality: { greater_than: 0 }
  validates :action_type, inclusion: { in: ["buy", "sell"], message: "%{value} is not a valid action type" }

  def self.ransackable_attributes(auth_object = nil)
    [ "company_name", "action_type" ]
  end

end
