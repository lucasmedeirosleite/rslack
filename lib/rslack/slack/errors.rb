module RSlack
  module Slack
    class APIError < RuntimeError; end
    class MigrationInProgressError < APIError; end
    class NotAuthenticatedError < APIError; end
    class InvalidAuthError < APIError; end
    class AccountInactiveError < APIError; end
    class InvalidCharsetError < APIError; end
    class ConnectionFailedError < APIError; end
  end
end
