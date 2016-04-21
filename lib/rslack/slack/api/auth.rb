module RSlack
  module Slack
    module API

      module Auth

        # Public: Abstraction for the Slack Authentication test API method
        #         (https://api.slack.com/methods/auth.test)
        #
        # Examples
        #
        #   => client.auth
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
        def auth
          perform_call(url: 'auth.test')
        end
      end
    end
  end
end
