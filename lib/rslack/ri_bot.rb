module RSlack
  class RIBot
    include RTM::API
    include RTM::Live

    def begin_listen!
      connect!(url: start['url']) do |message, channel|

      end
    end
  end
end
