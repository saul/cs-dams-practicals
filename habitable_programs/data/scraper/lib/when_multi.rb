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
require_relative "util"

class WhenMulti
  def find_teaching_data(module_name)
    begin
      Util.get_table_rows(module_name, 'Teaching')
    rescue StandardError => e
      puts "Failed to find teaching data for the module #{module_name}"
      raise e
    end
  end

  def print_module(module_name)
    teaching_data = find_teaching_data module_name

    autumn, spring, summer = Util.find_term_names_in_text teaching_data
    puts "#{module_name} | #{autumn}      | #{spring}      | #{summer}      |"
  end

  def run(*module_names)
    puts "     | Autumn | Spring | Summer |"
    puts "---------------------------------"

    module_names.each { |module_name| print_module module_name }
  end
end

if __FILE__ == $0
  WhenMulti.new.run(*ARGV)
end