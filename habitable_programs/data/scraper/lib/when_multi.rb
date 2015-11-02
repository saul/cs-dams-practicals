# Run me using the command "vado scrape.rb DAMS SEPR HACS"

# Lists the terms in which *several* CS module run, by scraping a module
# descriptor webpages (e.g. https://www.cs.york.ac.uk/modules/dams.html)
# producing a table, for example:
#
#      | Autumn | Spring | Summer |
# ---------------------------------
# DAMS | y      | y      | n      |
# SEPR | y      | y      | y      |
# HACS | y      | n      | n      |

require "nokogiri"
require "open-uri"

class WhenMulti
  def find_teaching_data(module_name)
    begin
      doc = Nokogiri::HTML(open("https://www.cs.york.ac.uk/undergraduate/modules/#{module_name.downcase}.html"))
      rows = doc.css("table#ModuleInfo tr")
      teaching_row = rows.find { |row| row.inner_text.include?("Teaching") }

      teaching_row.at_css("td").inner_text
    rescue StandardError => e
      puts "Failed to find teaching data for the module #{module_name}"
      raise e
    end
  end

  def print_module(module_name)
    teaching_data = find_teaching_data module_name

    autumn = bool_to_yesno teaching_data.include?("Autumn")
    spring = bool_to_yesno teaching_data.include?("Spring")
    summer = bool_to_yesno teaching_data.include?("Summer")

    puts "#{module_name} | #{autumn}      | #{spring}      | #{summer}      |"
  end

  def run(*module_names)
    puts "     | Autumn | Spring | Summer |"
    puts "---------------------------------"

    module_names.each { |module_name| print_module module_name }
  end

  private

  def bool_to_yesno(cond)
    cond ? 'y' : 'n'
  end
end

if __FILE__ == $0
  WhenMulti.new.run(*ARGV)
end