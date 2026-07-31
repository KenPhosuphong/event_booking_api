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
    render json: event_json(event)
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
end
