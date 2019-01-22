require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'google_drive'

class Scrapper
  @@name_and_email = []  

  def url_and_name
   url = "http://annuaire-des-mairies.com/val-d-oise.html"
   doc = Nokogiri::HTML(open(url))
   url_path = doc.css("a[href].lientxt")
   name_and_url = []    
   url_path.map do |value|
   url_ville = value["href"]
   url_ville[0] = ""
   name_and_url << { "name" => value.text, "url" => "http://annuaire-des-mairies.com" + url_ville }
   end
   name_and_url
  end  

  def get_townhall_email(url)
   doc = Nokogiri::HTML(open(url))
   email = doc.xpath("/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]").text
 end  

 def get_all_email(name_and_url)
   @@name_and_email = []    
   name_and_url.map.with_index do |value, i|
    @@name_and_email << {value["name"] => get_townhall_email(value["url"])}
   end
   @@name_and_email
  end  


 def save_as_JSON
   json = File.open('../db/email.json', "w") do |f|
     f.write(@@name_and_email.to_json)
   end
 end

   def google_sheet
   session = GoogleDrive::Session.from_config("config.json")
   ws = session.spreadsheet_by_key("1hpjnN48U13ADYLTRwoHOm-JX0xwLHNQmiTXf371W4pk").worksheets[0]
   i=1
   @@name_and_email.each do |value| 
    ws[i,1]= value.keys.join 
    ws[i,2]=value.values.join  
    i+=1
 end
 ws.save   
end 

def save_as_csv 
 CSV.open('./db/email.csv', "wb") do |f|
    @@name_and_email.each do |element|
      f << [element.keys.join.to_s, element.values.join.to_s]
   end 
   end
end




   def perform
   get_all_email(url_and_name())
 end
end


