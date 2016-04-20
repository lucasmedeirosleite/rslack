module RSlack
  module Slack
    module API

      module RTM

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

      end

    end
  end
end
