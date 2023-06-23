require 'uri'
require 'net/http'

class MuseumsController < ApplicationController
  def index
    api_key = ENV['MAPBOX_API_KEY']
    long = params["long"]
    lat = params["lat"]
    proximity = "#{long}%2C#{lat}"

    url = URI("https://api.mapbox.com/geocoding/v5/mapbox.places/museum.json?proximity=#{proximity}&access_token=#{api_key}")
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
