class CreateFlights < ActiveRecord::Migration[8.0]
  def change
    create_table :flights do |t|
      t.string :flight_number
      t.timestamptz :start
      t.interval :duration
      t.references :arrival_airport, null: false, foreign_key: { to_table: :airports }
      t.references :departure_airport, null: false, foreign_key: {to_table: :airports }

      t.timestamps
    end
  end
end
