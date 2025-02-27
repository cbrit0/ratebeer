require 'rails_helper'

RSpec.describe Beer, type: :model do
  let(:test_brewery) { Brewery.new name: "test", year: 2000 }
  let(:test_style) { Style.new name: "test", description: "text" }

  it "is saved when name, style and brewery set" do
    beer = Beer.create name: "Trial", style: test_style, brewery: test_brewery

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved without a name" do
    beer = Beer.create style: test_style, brewery: test_brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
  
  it "is not saved without a style" do
    beer = Beer.create name: "Trial", brewery: test_brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end  
end
