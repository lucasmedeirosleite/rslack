require 'faye/websocket'
require 'eventmachine'

module RSlack
  module Slack
    module Live
      attr_reader :url, :socket_client

      # Public: Method that connects to the WebSocket server using the URL
      # of the server which is inside the response of the rtm.start call
      #
      # url - A WebSocket URL
      # block - A required block containing the action to be done when a message
      # event was triggered by the WebSocket server
      #
      # Examples
      #
      #   class Dummy
      #     include RSlack::Slack::LIVE
      #
      #     def some_slack_method
      #       connect!(url: 'a url') do |message, channel|
      #       end
      #     end
      #   end
      #
      #
      # Raises 'A valid url must be passed' (RuntimeError) if url was not passed
      # Raises 'A valid block must me passed' (RuntimeError) if block was not passed
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

      # Internal: Generic method to perform any call to Slack's API
      #
      # method -  Desired HTTP method (defaults to GET)
      # url - Slack's desired API method
      # block - An optional block containing the parameters of the request.
      #
      # Examples
      #
      #   class Dummy
      #     include RSlack::Slack::API
      #
      #     def some_slack_method(params = {})
      #       perform_call(method: :put, url: 'a-slack-method') do
      #         params
      #       end
      #     end
      #   end
      #
      #
      # Returns the response of the HTTP call or raises one of the following
      # errors:
      #
      #   ConnectionFailedError => HTTP Errors
      #   MigrationInProgressError => Error on Slack's RTM API: migration_in_progress
      #   NotAuthenticatedError => Error on Slack's RTM API: not_authed
      #   InvalidAuthError => Error on Slack's RTM API: invalid_auth
      #   AccountInactiveError => Error on Slack's RTM API: account_inactive
      #   InvalidCharsetError => Error on Slack's RTM API: invalid_charset
      def perform_call(method: :get, url:, &block)
        config = RSlack::Configuration.current
        url = "#{config.api_url}/#{url}?token=#{config.token}"
        params = {}

        begin
          params = block.call() if block_given?
          response = RestClient.send(method, url, params)
        rescue => e
          raise ConnectionFailedError.new(e)
        end

        response = JSON.parse response.body
        check_response response unless response['ok']
        response
      end

      # Internal: Checks if the body of the event triggered by the
      # WebSocket server can be passed to the bot.
      #
      # parsed -  Hash representing the parsed body of the event
      #
      # Returns true if: event is of the type 'message' and
      # id of the bot is nil or id of the user who sent the message is different
      # of the id of the bot and the message mentions the bot.
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
