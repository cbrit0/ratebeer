require 'rails_helper'

RSpec.describe Beer, type: :model do
  let(:test_brewery) { Brewery.create name: "test brewery", year: 2000 }

  it "is saved with a name, style, and brewery" do
    beer = Beer.create name: "testbeer", style: "teststyle", brewery: test_brewery

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved without a name" do
    beer = Beer.create style: "teststyle", brewery: test_brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
    beer = Beer.create name: "testbeer", brewery: test_brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a brewery" do
    beer = Beer.create name: "testbeer", style: "teststyle"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
