class Event < ApplicationRecord
    has_many :bookings, dependent: :destroy

    def tickets_available
        ticket_quantity - bookings.sum(:booking_quantity)
    end

end
