fp2 = File.open 'sobooks/baidu_links.txt', 'r'
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
