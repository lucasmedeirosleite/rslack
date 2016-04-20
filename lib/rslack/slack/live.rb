require 'faye/websocket'
require 'eventmachine'

module RSlack
  module Slack
    module Live
      attr_reader :url, :socket_client

      def connect!(url:, &block)
        raise 'A valid url must be passed' if url.nil? || url.empty?
        raise 'A valid block must me passed' unless block_given?
        @url = url

        EventMachine.run do
          @socket_client = Faye::WebSocket::Client.new(url)

          socket_client.on :message do |event|
            parsed = JSON.parse event.data

            if can_propagate? parsed
              user = parsed['user']
              text = parsed['text'].split(':').reverse.first
              channel = parsed['channel']
              block.call(text, channel)
            end
          end
        end
      end

      private

      def can_propagate?(parsed)
        return false if parsed['type'] != 'message'
        id.nil? ||
        (
          id != parsed['user'] &&
          parsed['text'].include?(id)
        )
      end
    end
  end
end
