# test/integration/bookings_test.rb
require "test_helper"

class BookingsTest < ActionDispatch::IntegrationTest
  setup do
    @event = Event.create!(name: "Test Night", date: 1.week.from_now, ticket_quantity: 10)
  end

  test "books tickets successfully" do
    post "/events/#{@event.id}/bookings",
         params: { email: "me@test.com", booking_quantity: 3 },
         as: :json

    assert_response :created
    assert_equal 7, @event.reload.tickets_available
  end

  test "rejects booking when not enough tickets" do
    post "/events/#{@event.id}/bookings",
         params: { email: "me@test.com", booking_quantity: 50 },
         as: :json

    assert_response :unprocessable_entity
    assert_equal 10, @event.reload.tickets_available
  end

  test "rejects invalid email" do
    post "/events/#{@event.id}/bookings",
         params: { email: "", booking_quantity: 1 },
         as: :json

    assert_response :unprocessable_entity
  end

  test "returns 404 for unknown event" do
    post "/events/999999/bookings",
         params: { email: "me@test.com", booking_quantity: 1 },
         as: :json

    assert_response :not_found
  end
end