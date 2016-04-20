require 'spec_helper'

describe RSlack::RIBot do
  subject(:bot) { RSlack::RIBot.new }

  it { is_expected.to respond_to(:begin_listen!) }
  it { is_expected.to be_a(RSlack::RTM::API) }
  it { is_expected.to be_a(RSlack::RTM::Live) }

  describe '#begin_listen!' do
    context "when not connect to Slack" do
      before do
        allow(bot).to receive(:start).and_raise(RSlack::RTM::API::APIError)
      end

      it 'fails to start' do
        expect { bot.begin_listen! }.to raise_error(RSlack::RTM::API::APIError)
      end
    end

    context 'when connect to Slack' do
      let(:url) { 'wss://socket-url.com' }
      let(:response) { { 'ok': true, 'url': url } }

      before do
        expect(bot).to receive(:start).and_return(response)
      end

      it 'retrieves web-socket-server url and connects to server' do
        expect(bot).to receive(:connect!)
        bot.begin_listen!
      end
    end
  end
end
