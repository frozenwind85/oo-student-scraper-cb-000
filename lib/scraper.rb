require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    doc = Nokogiri::HTML(open(index_url))
    a = doc.css(".student-card")
      a.each_with_index do |s,i|
      students[i] = {name: s.css(".student-name").text, location: s.css(".student-location").text, profile_url: s.css("a").attribute("href").value}
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    student = {}
    doc = Nokogiri::HTML(open(profile_url))
    social = doc.css(".social-icon-container a")
    student[:profile_quote] = doc.css(".profile-quote").text
    student[:bio] = doc.css(".bio-content .description-holder p").text
    social.each do |s|
      t = s.attribute("href").value
      if t.include?("twitter")
        student[:twitter] = t
      elsif t.include?("linkedin")
        student[:linkedin] = t
      elsif t.include?("github")
        student[:github] = t
      else
        student[:blog] = t
      end
    end
    student
  end

end
