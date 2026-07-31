

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