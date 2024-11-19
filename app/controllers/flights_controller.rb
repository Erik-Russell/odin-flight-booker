class FlightsController < ApplicationController
  def index
    @airport_name_options = Airport.all.map{ |a| [ a.name, a.id ] }

    @avaialbe_flight_times = Flight.pluck(:start).map do |time|
      time.in_time_zone(Time.zone)
    end.uniq

    @formatted_flight_times = @avaialbe_flight_times.map do |time|
      [time.strftime("%A, %B %d, %Y at %I:%M %p %Z"), time]
    end
  end
end
