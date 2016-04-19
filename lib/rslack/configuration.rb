class RSlack::Configuration
  class << self
    attr_reader :current
  end

  attr_accessor :token

  # Public: Create a configuration instance with a configuration block
  # and stores itself in its own class
  #
  # block - A required block that must set the token field with the token
  #         registered for your bot in your slack team bot section.
  #
  # Examples
  #
  #   RSlack::Configuration.configure do |config|
  #     config.token = ENV['SLACK_BOT_TOKEN']
  #   end
  #
  # Returns the configuration that was created
  def self.configure
    raise 'A configuration block must be passed' unless block_given?
    @current = self.new
    yield(@current)
    @current
  end
end
