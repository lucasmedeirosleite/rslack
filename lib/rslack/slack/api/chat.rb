module RSlack
  module Slack
    module API

      module Chat

        def send_message
          perform_call(method: :post, url: 'chat.postMessage') do
            {
              text: 'message',
              channel: 'channel'
            }
          end
        end
      end
    end
  end
end
