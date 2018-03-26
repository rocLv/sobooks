require 'selenium/webdriver'
require 'byebug'

include Selenium

d = WebDriver.for :safari

INGJI = "https://sobooks.cc/jingjiguanli/page/"
PAGE_NUM = 21
JINGJI = "https://sobooks.cc/jingjiguanli/page/"
PAGE_NUM = 21

PAGE_NUM.times do |n|
  puts "na"
  d.navigate.to "#{JINGJI}#{n + 1}"

  links =  d.find_elements :css, 'h3 a'

  links.each do |link|
    puts "navigate to #{link.attribute('href')}"
    d.navigate.to link.attribute('href')
    i = d.find_element :css, '.euc-y-i'
    i.send_keys '201818'
    i.submit

    mima = d.find_element(:css, '.e-secret').text.match(/[0-9a-z]+/)[0]
    byebug
    baidu_link = d.find_element(:css, '.fa-download+ a').attribute('href').split("=")[1]
    puts baidu_link

    d.navigate.to baidu_link
    i = d.find_element :tag_name, 'input'
    i.send_keys mima
    i.submit

    begin
      download =  d.find_element :css, '.icon-download+ .text'
    rescue
      sleep 1
      retry
    end
    download.click

  end
end

