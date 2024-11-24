require 'rails_helper'

describe "Beerlist page" do
  before :all do
    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(app, :browser => :chrome)
    end
    WebMock.allow_net_connect!
  end

  before :each do
    @brewery1 = FactoryBot.create(:brewery, name: "Koff")
    @brewery2 = FactoryBot.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryBot.create(:brewery, name: "Ayinger")
    @style1 = Style.create name: "Lager"
    @style2 = Style.create name: "Rauchbier"
    @style3 = Style.create name: "Weizen"
    @beer1 = FactoryBot.create(:beer, name: "Nikolai", brewery: @brewery1, style:@style1)
    @beer2 = FactoryBot.create(:beer, name: "Fastenbier", brewery:@brewery2, style:@style2)
    @beer3 = FactoryBot.create(:beer, name: "Lechte Weisse", brewery:@brewery3, style:@style3)
  end

  it "shows a known beer", :js => true do
    visit beerlist_path
    find('table').find('tr:nth-child(2)')
    save_and_open_page
    expect(page).to have_content "Nikolai"
  end

  it "displays beers sorted alphabetically by default" do
    rows = find('#beertable').all('.tablerow')

    beer_names = rows.map { |row| row.text.split(' ').first }

    expect(beer_names).to eq beer_names.sort
  end

  it "sorts beers alphabetically by style when clicking the 'style' column" do
    find('th span#style').click

    rows = find('#beertable').all('.tablerow')

    styles = rows.map { |row| row.find('td:nth-child(2)').text }

    expect(styles).to eq styles.sort
  end

  it "sorts beers alphabetically by brewery when clicking the 'brewery' column" do
    find('th span#brewery').click

    rows = find('#beertable').all('.tablerow')

    breweries = rows.map { |row| row.find('td:nth-child(3)').text }

    expect(breweries).to eq breweries.sort
  end
end
