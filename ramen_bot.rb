require 'slack-ruby-client'
require 'selenium-webdriver'


Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
  config.logger = Logger.new(STDOUT)
  config.logger.level = Logger::INFO
  fail 'Missing ENV[SLACK_API_TOKEN]!' unless config.token
end

Slack::RealTime::Client.config do |config|
  config.websocket_ping = 30
end

client = Slack::RealTime::Client.new

def setup_doc url
  puts 'setup_doc now'
  driver = Selenium::WebDriver.for :chrome # ブラウザ起動
  driver.navigate.to url
  driver
end

 def scrape url
  d = setup_doc url
  sleep(10) # 読み込みを待つために５秒間処理を止める
  shop_name = []
  shop_rank = []
  puts 'scrape now'
  shop_name_get = d.find_elements(:class => 'list-rst__rst-name-target')
  shop_name_get.each { |n| 
    shop_name.push(n.text)
  }

  p shop_name
  #shop_name_get.each { |n| puts n.text.to_s }
  #shop_name.each { |n| puts n.text }
  #p shop_rank_get = d.find_elements(:class, 'c-rating__star')
  #shop_rank .each { |n| puts n.text }
  #return shop_name, shop_rank
  d.quit  #ブラウザ終了
  puts "scraping done..."
  shop_name
end

def shuffle_number
  rank_num = rand(1..20)
  page_num = rand(1..20)
  return rank_num, page_num
end

client.on :hello do
  puts "Successfully connected, welcome '#{client.self.name}' to the '#{client.team.name}' team at https://#{client.team.domain}.slack.com."
end

client.on :message do |data|
  puts data

  client.typing channel: data.channel

  case data.text
  when 'ラーメン' then
    #client.message channel: data.channel, text: "Hi <@#{data.user}>!" 
    url = 'https://tabelog.com/tokyo/rstLst/MC/?SrtT=rt&sk=%E3%83%A9%E3%83%BC%E3%83%A1%E3%83%B3&svd=20190601&svt=1900&svps=2&Srt=D&sort_mode=1'
    shop_name = scrape(url)
    rank_num, page_num = shuffle_number
    p rank_num
    p page_num
    #shop_name, shop_rank = scrape
    client.message channel: data.channel, text: "オススメのラーメンは#{shop_name[rank_num]}だよ"
  when /^bot/ then
    client.message channel: data.channel, text: "Sorry <@#{data.user}>, what?"
  end
end

client.on :close do |_data|
  puts 'Connection closing, exiting.'
end

client.on :closed do |_data|
  puts 'Connection has been disconnected.'
  client.start!
end

client.start!
