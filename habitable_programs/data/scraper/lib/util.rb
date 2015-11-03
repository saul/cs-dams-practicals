module Util
  def self.bool_to_yesno(cond)
    cond ? 'y' : 'n'
  end

  def self.get_table_rows(module_name, heading)
    doc = Nokogiri::HTML(open("https://www.cs.york.ac.uk/undergraduate/modules/#{module_name.downcase}.html"))

    rows = doc.css "table#ModuleInfo tr"

    row = rows.find { |row| row.inner_text.include? heading }
    row.at_css("td").inner_text
  end

  def self.find_term_names_in_text(data)
    %w(Autumn Spring Summer).map { |term| data.include? term }.map { |x| bool_to_yesno x }
  end
end