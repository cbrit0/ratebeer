class WeatherApi
  def self.get_weather_in(city)
    url = "http://api.weatherstack.com/current?access_key=#{key}&query="

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    weather = response.parsed_response["current"]

    Weather.new(weather)
  end

  def self.key
    return nil if Rails.env.test? # while testing api is not needed, return nil
    raise 'WEATHER_APIKEY env variable not defined' if ENV['WEATHER_APIKEY'].nil?

    ENV.fetch('WEATHER_APIKEY')
  end
end
