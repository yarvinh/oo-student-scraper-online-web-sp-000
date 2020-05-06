require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
      students_names = doc.css(".student-name").map{|n|n.text}
      student_locations = doc.css(".student-location").map{|l|l.text}
      student_url = doc.css("a").map{|link| link['href']}
      counter = 0
      all_students = []
      while students_names.length > counter
        students = Hash.new
        students[:name] = students_names[counter]
        students[:location] = student_locations[counter]
        students[:profile_url] = student_url[counter + 1]
        all_students << students
        counter += 1
      end
        all_students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
   student_links = doc.css("a").map{|link| link['href']}
   quote = doc.css(".profile-quote").text
   student_links.delete("../")
   paragraph = doc.css("p").text
   twitter = student_links.grep(/(twitter)/).length  > 0  ? student_links.grep(/(twitter)/).join : nil
   linkidin = student_links.grep(/(linkedin)/).length  > 0  ? student_links.grep(/(linkedin)/).join : nil
   github = student_links.grep(/(github)/).length  > 0  ? student_links.grep(/(github)/).join : nil
   student = {:twitter => twitter, :linkedin => linkidin, :github => github,:blog => student_links[3],
     :profile_quote => quote, :bio => paragraph}
   student.select{|key,value| value != nil}
  end

end
