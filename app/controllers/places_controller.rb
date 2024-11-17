class PlacesController < ApplicationController
  def index
  end

  def show
    id = params[:id]
    # Assuming that we have stored the city and the search results in the session
    city = session[:last_searched_city]
    places = Rails.cache.read(city)

    @place = places.find { |place| place.id == id } if places
    return if @place

    redirect_to places_path, notice: "Place not found or session expired"
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    @weather = WeatherApi.get_weather_in(params[:city])
    session[:last_searched_city] = params[:city].downcase
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index, status: 418
    end
  end
end
