require 'open3'

class RSlack::RISearcher

  def self.find_docs(definition)
    output, error, status = Open3.capture3("ri #{definition}")
    return error if output.empty?
    output
  end
end
