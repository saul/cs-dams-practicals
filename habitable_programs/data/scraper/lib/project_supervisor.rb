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
    rows.select { |r| r.inner_text.include? 'CSE' }
        .reject { |r| r.inner_text.include? 'Teaching Staff' }
        .map do |r|
          name = r.css("td.white a").inner_text
          position = name_to_position name
          Academic.new(name: name, position: position)
        end
  end

  def rows
    # Parse the people webpage using a Ruby library called Nokogiri
    doc = Nokogiri::HTML(open("https://www.cs.york.ac.uk/people/"))
    # Select only the rows that describe a person
    doc.css("td.white").map(&:parent)
  end

  def name_to_position(name)
    if name.include?("Prof") || name.include?("Reader")
      :professor
    elsif name.include?("Senior") || name.include?("Fellow")
      :senior
    else
      :lecturer
    end
  end
end

ProjectSupervisors.new.run
