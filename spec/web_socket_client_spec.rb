require 'spec_helper'

describe RSlack::RTM::Live do
  class Dummy
    include RSlack::RTM::Live
  end

  subject(:client) { Dummy.new }

  it { is_expected.to respond_to(:url) }
  it { is_expected.to respond_to(:socket_client) }
  it { is_expected.to respond_to(:connect!) }

  describe '#connect!' do
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
            client.connect!(url: 'a-url')
          }.to raise_error('A valid block must me passed')
        end
      end

      context 'when block was passed' do
        let(:url) { 'a-url' }

        it 'starts an eventmachine loop with faye configuration' do
          expect(EventMachine).to receive(:run)
          client.connect!(url: url) do
          end
        end
      end
    end
  end
end
