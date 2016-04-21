module RSlack
  module Slack
    module API

      module Chat

        # Public: Abstraction for the Slack Authentication test API method
        #         (https://api.slack.com/methods/chat.postMessage)
        #
        # text - Desired message to be sent
        # on   - Desired channel where message is gonna be sent
        #
        # Examples
        #
        #   => client.send_message('some message', on: 'channel-id')
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
        def send_message(text, on:)
          perform_call(method: :post, url: 'chat.postMessage') do
            {
              text: text,
              channel: on
            }
          end
        end
      end
    end
  end
end
