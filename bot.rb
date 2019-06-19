require 'sinatra'
require 'sinatra/reloader'
require 'active_record'
require 'dotenv/load'
require 'slack-ruby-client'
require 'net/http'
require 'uri'
require 'json'


class Shop_data < ActiveRecord::Base
  establish_connection(
    adapter:  "postgresql",
    host:     "",
    username: "goi",
    password: "",
    database: "ramen_db"
  )
end


post "/ramen" do
#  Slack.configure do |conf|
#    puts 'Slack connecting...'
#    conf.token = 'xoxb-594188397760-650725056596-FQPrrfM4UXgmTRFM6rTxBI7Y'
#  end
#  client = Slack::RealTime::Client.new

  callback_data = Shop_data.find(1)
  sn = callback_data.shop_name
  ss = callback_data.shop_score
  su = callback_data.shop_url
  
  uri = URI.parse('https://hooks.slack.com/commands/THG5JBPNC/662374286836/xBxAgHxkbz9mOGMEnYyrwxhF')

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.start do
    request = Net::HTTP::Post.new(uri.path)
    request.set_form_data("おすすめのラーメン店は「#{sn}:#{ss}」だよ\n #{su}")
    http.request(request)
  end

  #  client.on :hello do
#    puts 'connected!'
#    client.message channel: "times_eigo", text: "#{URI.parse(su)}"
#  end
#  client.start!
end

get "/" do
  test = Shop_data.find(1)
  "#{test.shop_name}"
end
