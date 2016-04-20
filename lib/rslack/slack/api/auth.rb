module RSlack
  module Slack
    module API

      module Auth

        def auth
          perform_call(url: 'auth.test')
        end
      end
    end
  end
end
