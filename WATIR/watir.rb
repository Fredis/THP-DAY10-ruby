require 'watir'
require 'pry'

browser = Watir::Browser.new(:firefox)
browser.goto 'google.com'

search_bar = browser.text_field(class: 'gsfi')
search_bar.set("Hello World!")
search_bar.send_keys(:enter)

#ou utiliser directement le bouton de recherche et non la touche entrée de son clavier
=begin
submit_button = browser.button(type:"submit")
submit_button.click	
=end

browser.driver.manage.timeouts.implicit_wait = 3

search_result_divs = browser.divs(class:"rc")

search_result_divs.each do |div|
	puts div.h3.text
end

browser.close