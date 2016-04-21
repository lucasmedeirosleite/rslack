module RSlack
  class RIBot
    include Slack::API
    include Slack::Live

    attr_reader :id, :name

    # Public: Starts the bot itself following these steps:
    # - Call Slack's API method rtm.start
    # - Call Slack's API method auth.test
    # - Connects to the WebSocket server
    # - Returns the desired documention through the connected WebSocket
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

    # Internal: Returns the valid found documentation for the Classes, methods or
    # modules passed inside the message
    #
    # message - Definitions to find ruby docs about.
    # channel - Channel to send the found documentation back
    #
    def send_found_documentation(message, channel)
      documentation = message.split(' ').reduce('') do |acc, definition|
        acc += ( RISearcher.find_docs(definition) + "\n\n" )
      end
      send_message(documentation, on: channel)
    end
  end
end
