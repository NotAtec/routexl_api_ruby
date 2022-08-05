# frozen_string_literal: true

require_relative '../lib/route_xl'

describe RouteXL do
  let(:client) { RouteXL::RouteAPI.new('user', 'pass') }
  let(:bad_client) { RouteXL::RouteAPI.new('baduser', 'badpass') }

  describe '#status' do
    context 'correct response with valid auth keys' do  
      before do
        stub_request(:get, "https://api.routexl.com/status").
        with(
          headers: {
          'Authorization'=>'Basic dXNlcjpwYXNz',
          'Connection'=>'close',
          'Host'=>'api.routexl.com',
          'User-Agent'=>'http.rb/5.1.0'
          },
          basic_auth: ['user', 'pass']).
        to_return(status: 200, body: "", headers: {})
        end
      it 'returns the correct response' do
        expect(client.status).to eql(200)
      end
    end
  end

  describe '#distances' do
  end

  describe '#tour' do
  end

end
