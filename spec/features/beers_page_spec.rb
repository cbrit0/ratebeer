require 'rails_helper'

include Helpers

describe "Beers" do
  before :each do 
    FactoryBot.create(:brewery, name: "Schlenkerla", year: 1678)
    FactoryBot.create(:style, name: "Lager", description: "text")
    FactoryBot.create :user
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "can be created with valid input" do
    visit new_beer_path
    fill_in('beer[name]', with: 'Helles')
    select('Lager', from: 'beer[style_id]')
    select('Schlenkerla', from: 'beer[brewery_id]')
  
    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(1)
  end
  

  it "can not be created with without a name" do
    visit new_beer_path
    select('Lager', from: 'beer[style_id]')
    select('Schlenkerla', from: 'beer[brewery_id]')
  
    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(0)

    expect(page).to have_content "Name can't be blank"
  end

end

# rspec spec/features/beers_page_spec.rb

# save_and_open_page
