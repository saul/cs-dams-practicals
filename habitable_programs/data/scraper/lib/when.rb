# Run me using the command "vado scrape.rb DAMS"

# Lists the terms in which a CS module runs, by scraping a module
# descriptor webpage (e.g. https://www.cs.york.ac.uk/modules/dams.html)
# producing a table, for example:
#
#      | Autumn | Spring | Summer |
# ---------------------------------
# DAMS | y      | y      | n      |

require "nokogiri"
require "open-uri"
require_relative "when_multi"

if __FILE__ == $0
  WhenMulti.new.run(ARGV[0])
end