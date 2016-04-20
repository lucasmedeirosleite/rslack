require 'spec_helper'

describe RSlack::Slack::API do
  class Dummy
    include RSlack::Slack::API
  end

  subject(:api) { Dummy.new }

  it { expect(api).to respond_to(:start) }
  it { expect(api).to respond_to(:auth) }

  shared_examples 'an api method' do
    let(:token) { 'a-token' }
    let(:api_url) { 'http://some.url.com' }
    let(:configuration) { double }

    before do
      allow(RSlack::Configuration).to receive(:current).and_return(configuration)
      allow(configuration).to receive(:token).and_return(token)
      allow(configuration).to receive(:api_url).and_return(api_url)
    end

    context 'when an error happens' do
      shared_examples 'an erronious request' do
        let(:body) { "{\"ok\":false,\"error\":\"#{event}\"}" }
        let(:response) { double }

        before do
          expect(RestClient).to receive(:get).with("#{api_url}/#{url}?token=#{token}").and_return(response)
          allow(response).to receive(:body).and_return(body)
        end

        it 'warns with desired error' do
          expect{
            api.send(method)
          }.to raise_error expected_error
        end
      end

      context 'when an http error occurred' do
        before do
          allow(RestClient).to receive(:get).and_raise(RestClient::ResourceNotFound)
        end

        it 'warns that start call failed' do
          expect {
            api.send(method)
          }.to raise_error(RSlack::Slack::ConnectionFailedError)
        end
      end

      context 'when migration_in_progress' do
        let(:event) { 'migration_in_progress' }
        let(:expected_error) { RSlack::Slack::MigrationInProgressError }

        it_behaves_like 'an erronious request'
      end

      context 'when not_authed' do
        let(:event) { 'not_authed' }
        let(:expected_error) { RSlack::Slack::NotAuthenticatedError }

        it_behaves_like 'an erronious request'
      end

      context 'invalid_auth' do
        let(:event) { 'invalid_auth' }
        let(:expected_error) { RSlack::Slack::InvalidAuthError }

        it_behaves_like 'an erronious request'
      end

      context 'account_inactive' do
        let(:event) { 'account_inactive' }
        let(:expected_error) { RSlack::Slack::AccountInactiveError }

        it_behaves_like 'an erronious request'
      end

      context 'invalid_charset' do
        let(:event) { 'invalid_charset' }
        let(:expected_error) { RSlack::Slack::InvalidCharsetError }

        it_behaves_like 'an erronious request'
      end
    end

    context 'when request succeeds' do
      let(:body) { "{ \"ok\":true }" }
      let(:response) { double }

      before do
        expect(RestClient).to receive(:get).with("#{api_url}/#{url}?token=#{token}").and_return(response)
        allow(response).to receive(:body).and_return(body)
      end

      it 'makes a successful request' do
        expect(api.send(method)['ok']).to be_truthy
      end
    end
  end

  describe '#start' do
    let(:url) { 'rtm.start' }
    let(:method) { :start }

    it_behaves_like 'an api method'
  end

  describe '#auth' do
    let(:url) { 'auth.test' }
    let(:method) { :auth }

    it_behaves_like 'an api method'
  end
end
