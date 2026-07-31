class EventsController < ActionController::API
  def index
    events = Event.all

    result = events.map { |event| event_json(event) }

    render json: result
  end

  def show
    event = Event.find(params[:id])
    render json: event_json(event)
  end

  private

  def event_json(event)
    {
      id: event.id,
      name: event.name,
      date: event.date,
      tickets_available: event.tickets_available
    }
  end
end
