class Booking < ApplicationRecord
  belongs_to :event

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :booking_quantity, numericality: { only_integer: true, greater_than: 0 }
end