class Flight < ApplicationRecord
  belongs_to :arrival_airport
  belongs_to :departure_airport
end
