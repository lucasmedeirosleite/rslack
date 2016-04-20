module RSlack
  class RIBot
    include RTM::API

    def begin_listen!
      socket_url = start['url']
      RTM::Live::WebSocketClient.new(url: socket_url).connect! do |message, channel|
        
      end
    end
  end
end
