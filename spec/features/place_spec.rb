require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ) ]
    )

    allow(WeatherApi).to receive(:get_weather_in).with("kumpula").and_return(
      Weather.new( temperature: 5 )
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  context "when API returns multiple beer restaurants" do
    it "displays all beer restaurants on the page" do
      # Mock the API response to return multiple beer restaurants
      mock_response = [
        Place.new( name: "Brewery One", id: 1 ),
        Place.new( name: "Brewery Two", id: 2 )
      ]
      allow(BeermappingApi).to receive(:places_in).and_return(mock_response)

      allow(WeatherApi).to receive(:get_weather_in).with("kumpula").and_return(
        Weather.new( temperature: 5 )
      )

      # Make the request
      visit places_path
      fill_in('city', with: 'kumpula')
      click_button "Search"

      expect(page).to have_content 'Brewery One'
      expect(page).to have_content 'Brewery Two'
    end
  end

  context "when API returns no beer restaurants" do
    it "displays 'No locations in place name' message" do
      # Mock the API response to return an empty list
      allow(BeermappingApi).to receive(:places_in).and_return([])

      allow(WeatherApi).to receive(:get_weather_in).with("kumpula").and_return(nil)

      # Make the request with a location
      visit places_path
      fill_in('city', with: 'kumpula')
      click_button "Search"

      expect(page).to have_content 'No locations in kumpula'
    end
  end
end
