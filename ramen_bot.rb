require 'slack-ruby-client'
require 'selenium-webdriver'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/json'


get '/' do
  "Hoge"
end

post '/slack/commands' do
  "FooBar"
  # today = date_set
  # rank_num, page_num = shuffle_number
  # url = "https://tabelog.com/tokyo/rstLst/MC/#{page_num}/?Srt=D&SrtT=rt"
  #  shop_name, shop_score, shop_url = scrape(url)

  # p url
  # "オススメのラーメンは「#{shop_name[rank_num]} | 評価#{shop_score[rank_num]}」だよ\n#{shop_url[rank_num]}"
end

def setup_doc url
  puts 'setup_doc now'
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  driver = Selenium::WebDriver.for :chrome, options: options  # ヘッドレスモードでブラウザ起動
  driver
end

def scrape url
  d = setup_doc url
  d.get(url)
  shop_name = []
  shop_rank = []
  shop_url = []
  puts 'scrape now'
  shop_name_get = d.find_elements(:class => 'list-rst__rst-name-target')
  shop_name_get.each { |n| shop_name.push(n.text) }
  shop_rank_get = d.find_elements(:class => 'list-rst__rating-val')
  shop_rank_get.each { |n| shop_rank.push(n.text) }
  shop_url_get = d.find_elements(:class => 'cpy-rst-name')
  shop_url_get.each { |n| shop_url.push(n[:href]) }

  p shop_name
  p shop_rank
  p shop_url
  d.quit  #ブラウザ終了
  puts "scraping done..."
  return shop_name, shop_rank, shop_url
end

def shuffle_number
  rank_num = rand(1..20)
  page_num = rand(1..60)
  return rank_num, page_num
end

def date_set
  d = Time.new
  set_date = d.strftime("%Y%m%d")
  set_date
end


