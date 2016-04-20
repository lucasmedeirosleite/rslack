require 'faye/websocket'
require 'eventmachine'

module RSlack
  module RTM
    module Live
      attr_reader :url, :socket_client

      def connect!(url:, &block)
        raise 'A valid url must be passed' if url.nil? || url.empty?
        raise 'A valid block must me passed' unless block_given?
        @url = url

        me = self
        EventMachine.run do
          me.send(:socket_client=, Faye::WebSocket::Client.new(me.url))

          me.socket_client.on :message do |event|
          end
        end
      end

      private

      def socket_client=(client)
        @socket_client = client
      end
    end
  end
end
