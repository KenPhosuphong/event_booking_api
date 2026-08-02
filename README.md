## Setup

    bundle install
    bin/rails db:create db:migrate db:seed
    bin/rails server

## Test

    bin/rails db:test:prepare
    bin/rails test

## Endpoints

    GET  /events                    list events with tickets available
    GET  /events/:id                one event
    POST /events/:id/bookings       book tickets
    PUT  /events/:id                update an event's data
    GET  /bookings                  list all bookings
    DELETE /bookings/:id            cancel bookings

    This is a small project so I didn't add bruno/postman file we will test using bash 

    Example:

        POST

        curl -X POST http://localhost:3000/events/1/bookings \
        -H "Content-Type: application/json" \
        -d '{"email":"me@test.com","booking_quantity":4}'

        PUT

        curl -X PUT http://localhost:3000/events/1 \
        -H "Content-Type: application/json" \
        -d '{"name":"Updated Event Name"}'
        
        DELETE

        curl -X DELETE http://localhost:3000/bookings/1

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

## MORE Extras

I also added delete and put method because I want this to be CRUD backend example

## If I had more time

Add tests for cancel booking and event update

Add user accounts, to let users see their own bookings.

or money transaction