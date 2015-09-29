require 'open-uri'
require 'nokogiri'
require 'csv'

# Store url to be scraped
url = "https://www.airbnb.com/s/Brooklyn--NY--United-States"

# Parse the page with Nokogori
page = Nokogiri::HTML(open(url))


# Scrape the max number of pages and store in max_page variable
page_numbers = []
page.css("div.pagination ul li a[target]").each do |line|
  page_numbers << line.text
end


page_numbers.pop()

# puts page_numbers

# puts page_numbers.length

# puts page_numbers.last
max_page = page_numbers.last

# Intitialze empty arrays
name = []
price = []
details =[]

# Loop once for every page of search results
max_page.to_i.times do |i|

  # Open search results page
  url = "https://www.airbnb.com/s/Brooklyn--NY--United-States?page=#{i+1}"
  page = Nokogiri::HTML(open(url))

  # Store data in arrays
  page.css('h3.h5.listing-name').each do |line|
    name << line.text.strip
  end

  page.css('span.h3.price-amount').each do |line|
    price << line.text
  end

  page.css('div.text-muted.listing-location.text-truncate').each do |line|
    subarray = line.text.gsub(/\s+[^a-zA-Z0-9]/, " ").strip.split(/ . /)

    if subarray.length == 2
      details << subarray
    else
      details << [subarray[0], "0 reviews"]
    end
  end

end

# puts details

# # Write data to CSV file
CSV.open("airbnb_listings.csv", "w") do |file|
  file << ["Listing Name","Price", "Room Type", "Reviews"]
  name.length.times do |i|
    file << [name[i], price[i], details[i][0], details[i][1] ]
  end
end
