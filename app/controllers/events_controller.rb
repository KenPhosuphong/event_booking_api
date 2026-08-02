class EventsController < ActionController::API
  def index
    events = Event.all
    booked = Booking.group(:event_id).sum(:booking_quantity)

    render json: events.map { |event|
      event_json(event, event.ticket_quantity - booked.fetch(event.id, 0))
    }
  end

  def show
    event = Event.find(params[:id])
    booked = Booking.where(event_id: event.id).sum(:booking_quantity)
    render json: event_json(event, event.ticket_quantity - booked)
  end

  def update
    event = Event.find(params[:id])
    if event.update(event_params)
      booked = Booking.where(event_id: event.id).sum(:booking_quantity)
      render json: event_json(event, event.ticket_quantity - booked)
    else
      render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def event_json(event, available = nil)
    {
      id: event.id,
      name: event.name,
      date: event.date,
      tickets_available: available || event.tickets_available
    }
  end

  def event_params
    params.permit(:name, :date, :ticket_quantity)
  end
end
