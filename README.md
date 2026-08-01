## Setup

    bundle install
    bin/rails db:create db:migrate db:seed
    bin/rails server

## Endpoints

    GET  /events                    list events with tickets available
    GET  /events/:id                one event
    POST /events/:id/bookings       book tickets
    GET  /bookings                  list all bookings

    Example:

        curl -X POST http://localhost:3000/events/1/bookings \
        -H "Content-Type: application/json" \
        -d '{"email":"me@test.com","booking_quantity":4}'

## Data modeling

I don't store "tickets left" as a column. It's calculated as
`ticket_quantity - sum of bookings`. That way bookings are the single
source of truth and the number can't drift out of sync if something
fails halfway.

## How I handle concurrency

The problem: if two users request the last ticket at the same time, both
can read "1 available" before either writes, and both get booked. Oversold.

I wrap it in a transaction first, so if money gets involved later I don't
need to change much.
https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html

Then the lock. If user A and user B request at the exact same time, the
row gets locked for one of them. The other waits until that request is
done, then re-reads the real count and gets rejected.
https://api.rubyonrails.org/classes/ActiveRecord/Locking/Pessimistic.html


## Extras

I added a `GET /bookings` endpoint to make it easier to see all bookings.

I also added validations: email and booking_quantity must not be nil, and
booking_quantity must be greater than 0.

#### If I had more time

Add cancel booking

Add user accounts. to let user see their own bookings.

or money transaction :P