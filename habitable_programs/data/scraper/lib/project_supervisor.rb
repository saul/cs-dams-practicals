# Update...

require "nokogiri"
require "open-uri"
require_relative "academic"

class ProjectSupervisors
  def run
    academics.each do |academic|
      puts "#{academic.name.ljust(30)} Score: #{academic.wisdom + academic.availability}.    Bribe: #{academic.bribe}"
    end
  end

  private

  def academics
    rows.reduce([]) do |memo, r|
      if r.inner_text.include?('CSE')
        unless r.inner_text.include?('Teaching Staff')
          name = r.css("td.white a").inner_text
          position = name_to_position name
          memo << Academic.new(name: name, position: position)
        end
      end
    end
  end

  def rows
    # Parse the people webpage using a Ruby library called Nokogiri
    doc = Nokogiri::HTML(open("https://www.cs.york.ac.uk/people/"))
    # Select only the rows that describe a person
    doc.css("td.white").map(&:parent)
  end

  def name_to_position(name)
    if r.inner_text.include?("Prof") || r.inner_text.include?("Reader") then
      position = :professor
    elsif r.inner_text.include?("Senior") || r.inner_text.include?("Fellow") then
      position = :senior
    else
      position = :lecturer
    end
  end
end

ProjectSupervisors.new.run
