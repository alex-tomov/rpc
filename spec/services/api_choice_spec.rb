# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApiChoice do
  subject(:api_choice) { described_class.new }

  let(:error_response_body) { { "message": 'Internal server error' }.to_json }
  let(:success_response_body) { { "statusCode": 200, "body": 'rock' }.to_json }
  let(:headers) do
    {
      'Accept' => '*/*',
      'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'User-Agent' => 'Ruby'
    }
  end

  def stub_mock_url
    allow(api_choice).to receive(:api_url).and_return(ApiChoice::RPS_MOCK_URL)

    stub_request(:get, 'https://private-anon-4b42eef306-curbrockpaperscissors.apiary-mock.com/rps-stage/throw')
      .with(headers: headers.merge('Host' => 'private-anon-4b42eef306-curbrockpaperscissors.apiary-mock.com'))
      .to_return(status: 200, body: success_response_body)
  end

  def stub_prod_url
    allow(api_choice).to receive(:api_url).and_return(ApiChoice::RPS_API_URL)

    stub_request(:get, ApiChoice::RPS_API_URL)
      .with(headers: headers.merge('Host' => '5eddt4q9dk.execute-api.us-east-1.amazonaws.com'))
      .to_return(status: 500, body: error_response_body)
  end

  describe '#call' do
    context 'when the remote API returns a valid response' do
      before { stub_mock_url }

      it 'returns a symbol representing the choice' do
        expect(api_choice.call).to eq(:rock)
      end
    end

    context 'when the remote API returns an invalid response' do
      before { stub_prod_url }

      it 'returns nil' do
        expect(api_choice.call).to be_nil
      end
    end

    context 'when there is a socket error' do
      before do
        allow(api_choice).to receive(:api_url).and_return(ApiChoice::RPS_API_URL)
        stub_request(:get, ApiChoice::RPS_API_URL).to_raise(SocketError, 'Socket Error')
      end

      it 'returns nil and logs an error message' do
        expect(Rails.logger).to receive(:error).with(/Error calling/)
        expect(api_choice.call).to be_nil
      end
    end
  end

  describe '#success?' do
    context 'when the response is a Net::HTTPSuccess object' do
      before { stub_mock_url }

      it 'returns true' do
        expect(api_choice.send(:success?)).to be true
      end
    end

    context 'when the response is not a Net::HTTPSuccess object' do
      before { stub_prod_url }

      it 'returns false' do
        expect(api_choice.send(:success?)).to be false
      end
    end
  end
end
