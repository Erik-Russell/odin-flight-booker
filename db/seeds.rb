# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'csv'

csv_path = Rails.root.join('db', 'large_airports.csv')

puts "Seeding airports from: #{csv_path}"

CSV.foreach(csv_path, headers: true) do |row|
  # Debug: Output the row being processed
  puts "Processing: #{row['ident']} - #{row['name']}"

  Airport.find_or_create_by!(code: row['ident']) do |airport|
    airport.name = row['name']
  end
end

puts "Total airports seeded: #{Airport.count}"

Flight.create!([{
  flight_number: 'AA756',
  start: Time.now + 3.hours,
  duration: 4.hours,
  arrival_airport_id: 33,
  departure_airport_id: 55
},
{
  flight_number: 'SK246',
  start: Time.now + 1.day,
  duration: 4.hours,
  arrival_airport_id: 23,
  departure_airport_id: 25
}])

puts "Created Flights"
