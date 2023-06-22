require 'uri'
require 'net/http'

class MuseumsController < ApplicationController
  def index
    api_key = ENV['MAPBOX_API_KEY']
    proximity = '-73.990593,40.740121'

    coordinates_url = URI("https://api.mapbox.com/geocoding/v5/mapbox.places/museum.json?proximity=#{proximity}&access_token=#{api_key}")
    coordinates_response = Net::HTTP.get(coordinates_url)
    coordinates_json = JSON.parse(coordinates_response)
    coordinates = coordinates_json['features'][0]['center']

    url = URI("https://api.mapbox.com/geocoding/v5/mapbox.places/museum.json?proximity=#{coordinates.join(',')}&access_token=#{api_key}")
    response = Net::HTTP.get(url)
    json = JSON.parse(response)
    museums = json['features']
    @museums = museums.each_with_object({}) do |feature, hash|
      context = feature['context']
      next if context.empty?
      postal_code = context[1]['text']
      hash[postal_code] ||= []
      hash[postal_code] << feature['text']
    end
    render json: @museums
  end
end
