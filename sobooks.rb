require 'selemium/webdriver'

include Selemium

def hrefs
  
end


d = WebDriver.for :safari
hrefs.each do |href|
  d.navigate.to href
  input = d.find_element :css, '.euc-y-i'
  input.send_keys '201818'
  input.submit
  mima = d.find_element(:css, '.e-secret').text.match(/[0-9a-z]+/)[0]
  baidu_link = d.find_element(:css, '.fa-download+ a').attribute('href').split("=")[1]
  p "#{mima}, #{baidu_link}"
end
hrefs.each do |href|
  d.navigate.to href
  input = d.find_element :css, '.euc-y-i'
  input.send_keys '201818'
  input.submit
  sleep 3
  mima = d.find_element(:css, '.e-secret strong').text.match(/[0-9a-z]+/)[0]
  baidu_link = d.find_element(:css, '.fa-download+ a').attribute('href').split("=")[1]
  p "#{mima}, #{baidu_link}"
end
limit = 0
hrefs.each do |href|
  begin
    d.navigate.to href
    input = d.find_element :css, '.euc-y-i'
    input.send_keys '201818'
    input.submit
    sleep 5
    mima = ''
    loop { mima = d.find_element(:css, '.e-secret').text.match(/[0-9a-z]+/)[0]; break if mima != 'hrome' }
    baidu_link = d.find_element(:css, '.fa-download+ a').attribute('href').split("=")[1]
    book_name = d.find_elements(:css, '.article-title a').first.text
    p "#{mima}, #{baidu_link}, #{book_name}"
  rescue
    puts "faild: #{href}"
  end
  hrefs.shift
end

hrefs = []
21.times do |n|
  begin
    puts "navigate to #{JINGJI}#{n + 1}"
    d.navigate.to "#{JINGJI}#{n + 1}"
    d.find_elements(:css, 'h3 a').map do |href|
      hrefs << href.attribute('href')
    end
  rescue
    sleep 5
    retry
  end
end

