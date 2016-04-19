require 'spec_helper'

describe RSlack::Configuration do

  it { is_expected.to respond_to(:token) }
  it { is_expected.to respond_to(:token=) }
  it { expect(subject.class).to respond_to(:configure) }
  it { expect(subject.class).to respond_to(:current) }

  describe '.configure' do
    context 'when configuration block is not passed' do

      it 'warns that configuration block was not passed' do
        expect {
          RSlack::Configuration.configure
        }.to raise_error('A configuration block must be passed')
      end
    end

    context 'when configuration block is passed' do
      let(:configuration) do
        RSlack::Configuration.configure do |config|
          config.token = 'some-token'
        end
      end

      it 'returns a configuration instance' do
        expect(configuration).to be_a(RSlack::Configuration)
      end

      it 'must have a token configured' do
        expect(configuration.token).not_to be_nil
      end
    end
  end

  describe '.current' do
    context 'when configuration exists' do
      let!(:configuration) do
        RSlack::Configuration.configure do |config|
          config.token = 'some-token'
        end
      end

      it 'returns the current configuration' do
        expect(RSlack::Configuration.current).to eq configuration
      end
    end
  end
end
