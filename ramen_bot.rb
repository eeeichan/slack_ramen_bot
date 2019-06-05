require 'selenium-webdriver'
require 'google_drive'


def spread_set
  # spreadsheet set
  session = GoogleDrive::Session.from_config("config.json")
  ## https://docs.google.com/spreadsheets/d/18fgahTOPCefIgbcQXnmTjx42vFpsiTyO4DDRUc3dFfw/edit?usp=sharing
  sheet = session.spreadsheet_by_key("18fgahTOPCefIgbcQXnmTjx42vFpsiTyO4DDRUc3dFfw").worksheets[0]
  sheet
end

def spread_reset sheet
  # sheet max range get
  row = 2
  while sheet.input_value(row,2) != "" do
    sheet.input_value(row,3) != "" && sheet.input_value(row,4) != "" ? row += 1 : break
  end

  # sheet reset
  row.downto(2) do |row|
    sheet[row,1] = ""
    sheet[row,2] = ""
    sheet[row,3] = ""
    sheet[row,4] = ""
  end
  sheet.save
end



#sp[2, 1] = "foo" # セルA2
#sp[2, 2] = "bar" # セルB2
#sp.save


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


  sheet = spread_set
  spread_reset sheet
  # 
  #today = date_set
  #rank_num, page_num = shuffle_number
  page_num = 1
  count = 0
  60.times do
    shop_num = 0
    url = "https://tabelog.com/tokyo/rstLst/MC/#{page_num}/?Srt=D&SrtT=rt"
    shop_name, shop_score, shop_url = scrape(url)

    val_num = shop_name.count
    row = 1 + (count * 20)
    val_num.times do
      sheet[row+1,1] = row
      sheet[row+1,2] = shop_name[shop_num]
      sheet[row+1,3] = shop_score[shop_num]
      sheet[row+1,4] = shop_url[shop_num]
      row += 1
      shop_num += 1
    end
    page_num += 1
    count += 1
    sheet.save
  end
  # p url
  # "オススメのラーメンは「#{shop_name[rank_num]} | 評価#{shop_score[rank_num]}」だよ\n#{shop_url[rank_num]}"

