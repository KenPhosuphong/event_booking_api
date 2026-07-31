class BookingsController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: "Event not found" }, status: :not_found
  end
  
  def index
    bookings = Booking.all

    render json: bookings.map { |booking|
      {
        id: booking.id,
        email: booking.email,
        booking_quantity: booking.booking_quantity,
        event: booking.event.name
      }
    }
  end
  
  def create
    ActiveRecord::Base.transaction do
      
      event = Event.lock.find(params[:event_id])
      booking = event.bookings.build(booking_params)

      if booking.booking_quantity.to_i > event.tickets_available
        render json: { error: "Not enough tickets available" }, status: :unprocessable_entity
      elsif booking.save
        render json: { message: "Booking created successfully" }, status: :created
      else
        render json: { errors: booking.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  private

  def booking_params
    params.permit(:email, :booking_quantity)
  end
end
