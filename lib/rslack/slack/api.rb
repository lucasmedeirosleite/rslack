require 'rest-client'
require_relative './api/auth'
require_relative './api/chat'
require_relative './api/rtm'

# Public: Various RTM API methods.
#
# Examples
#
#   class Client
#     include RSlack::RTM::API
#   end
module RSlack
  module Slack
    module API
      include Auth
      include Chat
      include RTM

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

      # Internal: Generic method to raise the correct exception based
      # on the error returned inside the Slack's API response
      #
      # response -  Erronious Slack's API response
      #
      # Raises one of the following
      # errors:
      #
      #   ConnectionFailedError => HTTP Errors
      #   MigrationInProgressError => Error on Slack's RTM API: migration_in_progress
      #   NotAuthenticatedError => Error on Slack's RTM API: not_authed
      #   InvalidAuthError => Error on Slack's RTM API: invalid_auth
      #   AccountInactiveError => Error on Slack's RTM API: account_inactive
      #   InvalidCharsetError => Error on Slack's RTM API: invalid_charset
      # Or returns nil if the error is not mapped
      def check_response(response)
        exception = case response['error']
          when 'migration_in_progress'
            MigrationInProgressError
          when 'not_authed'
            NotAuthenticatedError
          when 'invalid_auth'
            InvalidAuthError
          when 'account_inactive'
            AccountInactiveError
          when 'invalid_charset'
            InvalidCharsetError
        end

        raise exception unless exception.nil?
      end
    end
  end
end
