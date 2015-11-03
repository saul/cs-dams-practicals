# Lists the terms in which a CS module is assessed), by scraping a module
# descriptor webpage (e.g. https://www.cs.york.ac.uk/modules/dams.html)
# producing a table, for example:
#
#      | Autumn | Spring | Summer |
# ---------------------------------
# NUMA | n      | y      | y      |
#
# This scraper doesn't consider open assessments, and doesn't work for modules
# with more than one closed assessment. This is deliberate!

require "nokogiri"
require "open-uri"
require_relative "util"

class ClosedAssessment
  def run(module_name)
    assessment_data = Util.get_table_rows(module_name, 'Assessment')
    analyse(module_name, assessment_data)
  end

  def analyse(module_name, assessment_data)
    # Check which terms are included in that text
    autumn, spring, summer = Util.find_term_names_in_text assessment_data

    # Print out a summary of the findings
    puts "     | Autumn | Spring | Summer |"
    puts "---------------------------------"
    puts "#{module_name} | #{autumn}      | #{spring}      | #{summer}      |"
  end
end

ClosedAssessment.new.run(ARGV[0])
