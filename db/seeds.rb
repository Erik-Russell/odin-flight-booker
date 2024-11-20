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
require 'faker'

csv_path = Rails.root.join('db', 'large_us_airports.csv')

puts "Seeding airports from: #{csv_path}"

CSV.foreach(csv_path, headers: true) do |row|
  # Debug: Output the row being processed
  puts "Processing: #{row['ident']} - #{row['name']}"

  Airport.find_or_create_by!(code: row['ident']) do |airport|
    airport.name = row['name']
  end
end

puts "Total airports seeded: #{Airport.count}"

# Generate flights
airports = Airport.pluck(:id)

if airports.size < 2
  puts "not enough airports"
  exit
end

# Generate random start times within a range
time_range = (Time.now - 7.days)..(Time.now + 7.days)

# Generate flight numbers
def generate_flight_number
  "#{Faker::Alphanumeric.alpha(number: 2).upcase}#{rand(100..999)}"
end

# store some shared attributes
shared_departure_airport = airports.sample
shared_arrival_airport = airports.sample
shared_start_time = Faker::Time.between(from: time_range.first, to: time_range.last)

25.times do
  Flight.create!(
    flight_number: generate_flight_number,
    departure_airport_id: [shared_departure_airport, airports.sample].sample,
    arrival_airport_id: [shared_arrival_airport, airports.sample].sample,
    start: [shared_start_time, Faker::Time.between(from: time_range.first, to: time_range.last)].sample,
    duration: rand(1..5).hours + rand(0..59).minutes
  )
end

puts "25 flights with some overlap seeded!"
