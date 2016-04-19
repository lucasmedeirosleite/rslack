module RSlack
  class RIBot
    include RTM::API

    def begin_listen!
      socket_url = start['url']
      RTM::Live::WebSocketClient.connect!(url: socket_url) do |message, channel|

      end
    end
  end
end
