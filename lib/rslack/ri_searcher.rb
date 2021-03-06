require 'open3'

class RSlack::RISearcher

  # Public: Make a command line call to ri, searching for the
  #         documentation for the desired definition
  #         it can be a class, a module or a method
  #
  # definition - A String that can be a class name, a module name or a method
  #              name
  #
  # Examples
  #
  # => RSlack::RISearcher.find_definition('String')
  # => RSlack::RISearcher.find_definition('Array#first')
  # => RSlack::RISearcher.find_definition('Enumerable')
  # => RSlack::RISearcher.find_definition('non-ruby-definition')
  #
  # Returns an empty message if documentation was not found or
  #         the documentation found for this definition
  def self.find_docs(definition)
    Open3.capture3("ri -f markdown --no-pager #{definition}").first
  end
end
