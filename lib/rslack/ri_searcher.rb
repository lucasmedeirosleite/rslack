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
  # Returns a message saying that the documentation was not found or
  #         the documentation found for this definition
  def self.find_docs(definition)
    output, error, status = Open3.capture3("ri #{definition}")
    return error if output.empty?
    output
  end
end
