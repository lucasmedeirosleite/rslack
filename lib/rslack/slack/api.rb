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
