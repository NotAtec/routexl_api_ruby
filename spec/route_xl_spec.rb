# frozen_string_literal: true

require_relative '../lib/route_xl'

describe RouteXL do
  let(:client) { RouteXL::RouteAPI.new('user', 'pass') }

  describe '#status' do
    context 'correct response with valid auth keys' do
      let(:response) do
        {
          #TD: Add copied response
        }
      end

      it 'returns the correct response' do
        stub_request(:get, 'https://api.routexl.com/status/').to_return(body: response)
        expect(client.status).to eql('200')
      end
    end

    context 'correct response with invalid auth keys' do
      let(:bad_client) { RouteXL::RouteAPI.new('baduser', 'badpass') }
      let(:response) do
        {
          #TD: Add copied response
        }
      end

      it 'returns the correct response' do
        stub_request(:get, 'https://api.routexl.com/status/').to_return(body: response)
        expect(client.status).to eql('401')
      end
    end
  end

  describe '#distances' do
  end

  describe '#tour' do
  end

end
