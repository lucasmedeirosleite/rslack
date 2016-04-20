require 'spec_helper'

describe RSlack::RIBot do
  subject(:bot) { RSlack::RIBot.new }

  it { is_expected.to be_a(RSlack::Slack::API) }
  it { is_expected.to be_a(RSlack::Slack::Live) }

  it { is_expected.to respond_to(:id) }
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:begin_listen!) }

  describe '#begin_listen!' do
    context "when not connect to Slack" do
      before do
        allow(bot).to receive(:start).and_raise(RSlack::Slack::APIError)
      end

      it 'fails to start' do
        expect { bot.begin_listen! }.to raise_error(RSlack::Slack::APIError)
      end
    end

    context 'when connect to Slack' do
      let(:url) { 'wss://socket-url.com' }
      let(:response)  { { 'ok' => true, 'url' => url } }
      let(:user_data) { { 'ok' => true, 'user' => 'user_name', 'user_id' => 'user_id' }}
      let(:message) { 'a message' }
      let(:channel) { 'a channel' }

      before do
        expect(bot).to receive(:start).and_return(response)
        expect(bot).to receive(:auth).and_return(user_data)
        expect(bot).to receive(:send_found_documentation).with(message, channel)
      end

      it 'retrieves web-socket-server url and connects to server' do
        expect(bot).to receive(:connect!).with(anything).and_yield(message, channel)
        bot.begin_listen!
        expect(bot.id).to eq 'user_id'
        expect(bot.name).to eq 'user_name'
      end
    end
  end
end
