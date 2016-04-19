require 'spec_helper'

describe RSlack::RTM::Live::WebSocketClient do

  it { is_expected.to respond_to(:url) }
  it { is_expected.to respond_to(:on_message) }
  it { expect(RSlack::RTM::Live::WebSocketClient).to respond_to(:connect!) }

  describe '#connect!' do
    subject(:client) { RSlack::RTM::Live::WebSocketClient }

    context 'when url was not passed' do
      shared_examples 'an invalid connection' do
        it 'does not connect' do
          expect {
            client.connect!(url: url)
          }.to raise_error('A valid url must be passed')
        end
      end

      context 'when url nil' do
        let(:url) { nil }

        it_behaves_like 'an invalid connection'
      end

      context 'when url empty' do
        let(:url) { '' }

        it_behaves_like 'an invalid connection'
      end
    end

    context 'when url passed' do
      context 'when block was not passed' do
        it 'does not connect' do
          expect {
            client.connect!(url: 'some-url')
          }.to raise_error('A valid block must me passed')
        end
      end

      context 'when block was passed' do
        let(:url) { 'some-url' }
        let(:on_message) { Proc.new { } }
        let(:client) do
          client = RSlack::RTM::Live::WebSocketClient.connect!(url: url, &on_message)
        end
        let(:faye) { double }

        before do
          expect(Faye::WebSocket::Client).to receive(:new).with(url).and_return(faye)
          expect(faye).to receive (:on)
        end

        it 'returns a web socket client' do
          expect(client).to be_a(RSlack::RTM::Live::WebSocketClient)
        end

        it 'has an url' do
          expect(client.url).to be url
        end

        it 'has an on_message callback' do
          expect(client.on_message).to be &on_message
        end
      end
    end
  end
end
