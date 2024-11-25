class BookingsController < ApplicationController
  def new
    @booking = Booking.new(flight_id: params[:flight_id])
    @number_of_passengers = params[:number_of_tickets].to_i
    @number_of_passengers.times { @booking.passengers.build }
  end

  def create
    @booking = Booking.new(booking_params)
    if @booking.save
      redirect_to @booking, notice: "Booking was successfully created."
    else
      render :new, status: :unprocessabel_entity
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:number_of_passengers, :flight_id, passengers_attributes: [:name, :email])
  end
end
