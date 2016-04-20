module RSlack
  class RIBot
    include Slack::API
    include Slack::Live

    def begin_listen!
      connect!(url: start['url']) do |message, channel|
      end
    end
  end
end
