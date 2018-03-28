require 'selenium/webdriver'

include Selenium

D = WebDriver.for :safari

BOOKS = {
          xiaoshuowenxue: 42,
          lishizhuanji:   22,
          renwensheke:    17,
          lizhichenggong: 5,
          # jingjiguanli:   21,
          xuexiaojiaoyu:  3,
          shenghoushishang: 2,
          yingwenyuanban:   2
         }.freeze

URL = 'https://sobooks.cc/'

def get_all_book_links
  BOOKS.each do |catalog, page_num|
    page_num.times do |n|
      puts "navigate: " + " #{URL}#{catalog}/page/#{n + 1}"
      write_to_book_links(catalog, get_book_links("#{URL}#{catalog}/page/#{n + 1}"))
    end
  end
rescue
end

def get_baidu_links(hrefs)
  links = [] 
  hrefs.each do |href|
    begin
      D.navigate.to href
      input = D.find_element :css, '.euc-y-i'
      input.send_keys '201818'
      input.submit
      sleep 5

      mima = ''
      loop { mima = D.find_element(:css, '.e-secret').text.match(/[0-9a-z]+/)[0]; sleep(2); break if mima != 'hrome' }
      baidu_link = D.find_element(:css, '.fa-download+ a').attribute('href').split("=")[1]
      book_name  = D.find_elements(:css, '.article-title a').first.text
      links << "#{baidu_link},#{book_name},#{mima}"
    rescue
      puts "faild: #{href}"
    end
    hrefs.shift
  end

  links.join("/n")
end

def batch_download(baidu_link)
  fp2 = File.open 'baidu_links.txt', 'r'
  fp2.rewind
  while(!fp2.eof) do
    begin
    mima, link = fp2.readline.split(", ")
    d.navigate.to link
    input = d.find_element(:tag_name, 'input')
    input.send_keys mima
    input.submit

    sleep 2
    download =  d.find_element(:css, '.icon-download+ .text')
    file_name = d.find_element(:css, '.file-name').text
    unless File.exist?("#{down_dir}#{file_name}")
      download.click
      sleep 10
    end
    rescue
      puts link
    end
  end
end

def write_to_book_links(catalog, links)
  write_to_file("#{catalog}_book_liks.txt", links )
end

def write_to_file(file_name, str)
  fp = File.open(file_name, 'a+')
  fp.puts str
  fp.close
end

def get_book_links(start_url)
  D.navigate.to start_url
  links = D.find_elements :css, 'h3 a'
  hrefs = []
  links.each do |href|
    hrefs << href.attribute('href')
  end

  hrefs.join('\n')
end

# get_all_book_links
BOOKS.each do |k, v|
  str = get_baidu_links(File.read("#{k}_book_liks.txt").split('\n'))
  write_to_file("#{k}_baidu.txt", str)
end
