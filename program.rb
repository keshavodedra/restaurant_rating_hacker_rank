require_relative 'connection'
require_relative 'restaurant_data'

class Program
  CITY = 'Seattle'.freeze

  def call
    resp = call_connection(CITY, 1)
    total_pages = resp['total_pages']
    data = []
    data << RestaurantData.new(resp['data'])

    2.upto(total_pages).each do |page|
      resp = call_connection(CITY, page)
      data << RestaurantData.new(resp['data'])
    end

    max_by_page = []
    data.each do |dt|
      max_by_page << dt.data.max_by { |d| d['user_rating']['average_rating'] }
    end

    n = max_by_page.max_by { |d| d['user_rating']['average_rating'] }
    max_rating = n['user_rating']['average_rating']

    names = []
    data.each do |dt|
      names << dt.data.select { |d| d['user_rating']['average_rating'] == max_rating }
    end

    restaurant_names = []
    names.each do |dt|
      restaurant_names << dt.map { |d| d['name'] }
    end
    restaurant_names.flatten.compact
  end

  def call_connection(city, page)
    conn = Connection.new(city, page)
    resp = conn.call
  end
end

output = Program.new.call
p output
