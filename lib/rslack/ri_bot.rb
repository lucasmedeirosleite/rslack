module RSlack
  class RIBot
    include Slack::API
    include Slack::Live

    attr_reader :id, :name

    def begin_listen!
      url = start['url']
      user_data = auth
      @id = user_data['user_id']
      @name = user_data['user']

      connect!(url: url) do |message, channel|
        send_found_documentation(message, channel)
      end
    end

    private

    def send_found_documentation(message, channel)
      documentation = message.split(' ').reduce('') do |acc, definition|
        acc += ( RISearcher.find_docs(definition) + "\n\n" )
      end
      send_message(documentation, on: channel)
    end
  end
end
