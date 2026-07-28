class CreateBookings < ActiveRecord::Migration[8.1]
  def change
    create_table :bookings do |t|
      t.references :event, null: false, foreign_key: true
      t.string :email
      t.integer :booking_quantity

      t.timestamps
    end
  end
end
