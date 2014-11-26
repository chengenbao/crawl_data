#!/usr/bin/env ruby 

require './http_requester'
require 'json'

daodaoid = ARGV[0]
url = "http://www.daodao.com/#{daodaoid}"
page = HttpRequester.get url, nil

# redirect
reg = /The document has moved <A HREF="([^<>]+)">here<\/A>/
match = page.scan reg

if match && match.length > 0
  url = match[0][0]

  page = HttpRequester.get url, nil

  reg = /all_single_meta_reqs = JSON.decode\('([^;]+)'\);/
  match = page.scan reg
  all_single_meta_reqs = match[0][ 0]

  all_single_meta_reqs = JSON.parse(all_single_meta_reqs)

  all_single_meta_reqs.each do |single_mata_req|
    data = JSON.dump(single_mata_req)
    puts data
    field = {}
    field['single_hotel_meta_req'] = data

    url = 'http://www.daodao.com/DaoDaoCheckRatesAjax?action=getSingleHotelMeta'
    page = HttpRequester.get url, field
    puts page
    puts
  end
end

