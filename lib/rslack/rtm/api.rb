require 'rest-client'

# Public: Various RTM API methods.
#
# Examples
#
#   class Client
#     include RSlack::RTM::API
#   end
module RSlack
  module RTM
    module API

      # Public: Abstraction for the Slack RTM API start method call
      #         (https://api.slack.com/methods/rtm.start)
      #
      # Examples
      #
      #   => client.start
      #
      # Returns a hash with the options explained on the api method call
      # definition on the website or the following errors:
      #
      #   ConnectionFailedError => HTTP Errors
      #   MigrationInProgressError => Error on Slack's RTM API: migration_in_progress
      #   NotAuthenticatedError => Error on Slack's RTM API: not_authed
      #   InvalidAuthError => Error on Slack's RTM API: invalid_auth
      #   AccountInactiveError => Error on Slack's RTM API: account_inactive
      #   InvalidCharsetError => Error on Slack's RTM API: invalid_charset
      def start
        config = RSlack::Configuration.current
        url = "#{config.api_url}/rtm.start?token=#{config.token}"

        begin
          response = RestClient.get(url)
        rescue => e
          raise ConnectionFailedError.new(e)
        end

        response = JSON.parse response.body
        check_response response unless response['ok']
        response
      end

      private

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
