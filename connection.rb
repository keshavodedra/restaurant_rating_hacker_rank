class Connection
  require 'net/http'
  require 'json'

  attr_reader :url_path, :city, :page

  def initialize(city, page)
    @url_path = 'https://jsonmock.hackerrank.com/api/food_outlets'
    @city = city
    @page = page
  end

  def call
    uri = URI(url_path)
    params = { city: city, page: page }
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    JSON.parse(res.body)
  end
end
