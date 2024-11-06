require 'rails_helper'

include Helpers

describe "Beer Creation" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Test Brewery", year: 2000 }
  
  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "adds a beer with a valid name to the system" do
    visit new_beer_path

    fill_in('beer[name]', with: "Test Beer")
    select("Test Brewery", from: 'beer[brewery_id]')
    select("Lager", from: "beer[style]")

    # Submit the form
    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)

    # Check if the beer was saved and we are redirected to the beer's details page
    expect(page).to have_content "Beer was successfully created"
    expect(Beer.count).to eq(1)
    expect(Beer.first.name).to eq("Test Beer")
  end

  it "does not add a beer with an invalid name and shows an error" do
    # Navigate to the beer creation page
    visit new_beer_path

    # Fill in an empty name
    fill_in('beer[name]', with: "")
    select("Test Brewery", from: 'beer[brewery_id]')
    select("Lager", from: 'beer[style]')

    # Submit the form
    click_button "Create Beer"

    # Check that we are redirected back to the beer creation page with an error message
    expect(page).to have_content "Name can't be blank"
    expect(current_path).to eq(beers_path)
    expect(Beer.count).to eq(0)
  end
end
