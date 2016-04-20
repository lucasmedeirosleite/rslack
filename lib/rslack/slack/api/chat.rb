module RSlack
  module Slack
    module API

      module Chat

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
