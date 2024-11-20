class FlightsController < ApplicationController
  def index
    @arrival_options = Flight.pluck(:arrival_airport_id).map do |arrival|
      [ Airport.find_by(id: arrival).code, arrival ].uniq
    end.uniq

    @departure_options = Flight.pluck(:departure_airport_id).map do |departure|
      [ Airport.find_by(id: departure).code, departure ]
    end.uniq

    @avaialbe_flight_times = Flight.pluck(:start).map do |time|
      time.in_time_zone(Time.zone)
    end.uniq.sort

    @formatted_flight_times = @avaialbe_flight_times.map do |time|
      [time.strftime("%A, %B %d, %Y at %I:%M %p %Z"), time]
    end

    arrival_airport_id = params[:arrival_airport_id]
    departure_airport_id = params[:departure_airport_id]
    start = params[:start]
    passengers = params[:passengers]

    # all flights
    @flights = Flight.all

    # flights that match arrival
    @flights_arr = @flights.where(arrival_airport_id: arrival_airport_id) if arrival_airport_id.present?

    # flights that match departure
    @flights_dep = @flights.where(departure_airport_id: departure_airport_id) if departure_airport_id.present?

    # flights by departure time
    if start.present?
      start_datetime = Time.zone.parse(start)
      time_range = (start_datetime - 30.minutes)..(start_datetime + 30.minutes)
      @flights_time = @flights.where(start: time_range)
    end

    # Combined search query
    @flights_avail = @flights.where(arrival_airport_id: arrival_airport_id) if arrival_airport_id.present?
    if @flights_avail.nil?
      @flights_avail = @flights.where(departure_airport_id: departure_airport_id) if departure_airport_id.present?
    else
      @flights_avail = @flights_avail.where(departure_airport_id: departure_airport_id) if departure_airport_id.present?
    end
    if start.present?
      start_time = Time.zone.parse(start)
      time_range = (start_datetime - 30.minutes)..(start_datetime + 30.minutes)
      if @flights_avail.nil?
        @flights_avail = @flights.where(start: time_range)
      else
        @flights_avail = @flights_avail.where(start: time_range)
      end
    end
  end
end
