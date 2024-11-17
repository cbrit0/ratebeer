class Weather < OpenStruct
  def self.rendered_fields
    [:temperature, :weather_icons, :wind_speed, :wind_dir]
  end
end
