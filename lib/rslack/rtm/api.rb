require 'rest-client'

module RSlack
  module RTM
    module API

      def start
        config = RSlack::Configuration.current
        url = "#{config.api_url}/rtm.start?token=#{config.token}"
        response = JSON.parse RestClient.get(url).body
        check_response response
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
