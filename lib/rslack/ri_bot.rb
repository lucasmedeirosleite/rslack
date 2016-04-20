module RSlack
  class RIBot
    include Slack::API
    include Slack::Live

    attr_reader :id, :name

    def begin_listen!
      url = start['url']
      user_data = auth
      @id = user_data['user_id']
      @name = user_data['user']

      connect!(url: url) do |message, channel|
        puts message
        puts channel
      end
    end

    def excluded_users
      [ id ]
    end
  end
end
