class VerificationProduct < ApplicationRecord
  has_many :order_items
  has_many :verification_tasks

  enum status: { active: 0, inactive: 1 }

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }


  def price_in_cents
    (price.to_f * 100_000).round
  end
end