require 'faye/websocket'

module RSlack
  module RTM
    module Live

      class WebSocketClient
        attr_reader :url, :on_message

        def self.connect!(url:, &block)
          raise 'A valid url must be passed' if url.nil? || url.empty?
          raise 'A valid block must me passed' unless block_given?
          self.new(url: url, &block)
        end

        def initialize(url: nil, &block)
          @url = url
          @on_message = block
          connect_to_faye
        end

        private

        def connect_to_faye
          @faye = Faye::WebSocket::Client.new(url)
          @faye.on :message do |event|
            puts event
          end
        end
      end
    end
  end
end
