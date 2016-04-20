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
          send(:socket_client=, Faye::WebSocket::Client.new(url))
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

      def excluded_users
        []
      end

      private

      def socket_client=(client)
        @socket_client = client
      end

      def can_propagate?(parsed)
        return false if parsed['type'] != 'message'
        excluded_users.empty? ||
        (
          !excluded_users.include?(parsed['user']) &&
          excluded_users.any? { |mention| parsed['text'].include?(mention) }
        )
      end
    end
  end
end
