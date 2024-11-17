require 'rails_helper'

describe "BeermappingApi" do
  describe "in case of cache miss" do

    before :each do
      Rails.cache.clear
    end

    it "When HTTP GET returns one entry, it is parsed and returned" do
      canned_answer = <<-END_OF_STRING
  <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>18856</id><name>Panimoravintola Koulu</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18856</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap><street>Eerikinkatu 18</street><city>Turku</city><state></state><zip>20100</zip><country>Finland</country><phone>(02) 274 5757</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
  END_OF_STRING

      stub_request(:get, /.*turku/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

      places = BeermappingApi.places_in("turku")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Panimoravintola Koulu")
      expect(place.street).to eq("Eerikinkatu 18")
    end

  end

  describe "in case of cache hit" do
    before :each do
      Rails.cache.clear
    end

    it "When one entry in cache, it is returned" do
      canned_answer = <<-END_OF_STRING
  <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>18856</id><name>Panimoravintola Koulu</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18856</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap><street>Eerikinkatu 18</street><city>Turku</city><state></state><zip>20100</zip><country>Finland</country><phone>(02) 274 5757</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
  END_OF_STRING

      stub_request(:get, /.*turku/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

      BeermappingApi.places_in("turku")
      places = BeermappingApi.places_in("turku")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Panimoravintola Koulu")
      expect(place.street).to eq("Eerikinkatu 18")
    end
  end
  
  it "When HTTP GET returns one entry, it is parsed and returned" do

    canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>18856</id><name>Panimoravintola Koulu</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18856</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap><street>Eerikinkatu 18</street><city>Turku</city><state></state><zip>20100</zip><country>Finland</country><phone>(02) 274 5757</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*turku/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("turku")

    expect(places.size).to eq(1)
    place = places.first
    expect(place.name).to eq("Panimoravintola Koulu")
    expect(place.street).to eq("Eerikinkatu 18")
  end

  it "returns an empty array when HTTP GET does not return any place" do
    # Stub the response for a request with an empty result
    empty_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*emptytown/).to_return(body: empty_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("emptytown")

    expect(places).to eq([]) # Expect an empty array
  end

  it "returns an array of Place objects when HTTP GET returns multiple places" do
    # Stubbed response for multiple places
    multiple_places_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations>
  <location>
    <id>1</id><name>Place One</name><status>Brewpub</status>
    <reviewlink>https://beermapping.com/location/1</reviewlink>
    <proxylink>http://beermapping.com/maps/proxymaps.php?locid=1&amp;d=5</proxylink>
    <blogmap>http://beermapping.com/maps/blogproxy.php?locid=1&amp;d=1&amp;type=norm</blogmap>
    <street>Main Street 1</street><city>Testtown</city>
    <state></state><zip>12345</zip><country>Finland</country>
    <phone>123456</phone><overall>4</overall><imagecount>2</imagecount>
  </location>
  <location>
    <id>2</id><name>Place Two</name><status>Bar</status>
    <reviewlink>https://beermapping.com/location/2</reviewlink>
    <proxylink>http://beermapping.com/maps/proxymaps.php?locid=2&amp;d=5</proxylink>
    <blogmap>http://beermapping.com/maps/blogproxy.php?locid=2&amp;d=1&amp;type=norm</blogmap>
    <street>Side Street 2</street><city>Testtown</city>
    <state></state><zip>12345</zip><country>Finland</country>
    <phone>654321</phone><overall>3</overall><imagecount>0</imagecount>
  </location>
</bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*testtown/).to_return(body: multiple_places_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("testtown")

    expect(places.size).to eq(2)
    expect(places.first.name).to eq("Place One")
    expect(places.first.street).to eq("Main Street 1")
    expect(places.last.name).to eq("Place Two")
    expect(places.last.street).to eq("Side Street 2")
  end

end
