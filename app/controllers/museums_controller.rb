# handling URL
require 'uri'
# making http requests
require 'net/http'

class MuseumsController < ApplicationController
  def index
    # API key is retrieved from the environment variable named MAPBOX_API_KEY.
    # Authentication and access to the Mapbox API.
    api_key = ENV['MAPBOX_API_KEY']
    # Constructs a URL using the URI class, specifying the API endpoint for retrieving museum data.
    url = URI("https://api.mapbox.com/geocoding/v5/mapbox.places/museum.json?proximity=-73.990593%2C40.740121&access_token=#{api_key}")
    # Sends an HTTP GET request to the constructed URL and retrieves the response.
    # Retrieves the JSON response from the API.
    response = Net::HTTP.get(url)
    # The retrieved JSON response is parsed using JSON.parse and stored in the json variable.
    json = JSON.parse(response)
    # The features key from the JSON response is extracted and assigned to the museums variable.
    # List of museum features returned by the API (includes museum/feature name and postal code)
    museums = json['features']
    # The @museums instance variable is initialized as an empty hash and then populated w/ data extracted from the museums list.
    # Iterates over each museum feature and extracts the postal code and museum/feature name.
    # It groups the features by postal code in the @museums hash.
    @museums = museums.each_with_object({}) do |feature, hash|
      context = feature['context']
      next if context.empty?
      postal_code = context[1]['text']
      hash[postal_code] ||= []
      hash[postal_code] << feature['text']
    end
    # Renders the @museums hash as JSON
    render json: @museums
  end
end
