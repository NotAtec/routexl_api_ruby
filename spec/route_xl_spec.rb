# frozen_string_literal: true

require_relative '../lib/route_xl'

describe RouteXL do
  let(:client) { RouteXL::RouteAPI.new('user', 'pass') }

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

  describe 'HTTP Response & Other errors' do
    let(:location) { instance_double("Location") }
    

    context 'Custom Error Testing' do
      before(:each) do
        allow(location).to receive(:instance_of?).with(RouteXL::Location).and_return(true)
      end
      
      it 'raises ClassError when non-location is given' do
        array = ['not_loca']
        expect { client.distances(array) }.to raise_error(RouteXL::ClassError)
      end

      it 'raises SubscriptionError when 403 is returned' do
        stub_request(:post, "https://api.routexl.com/distances").
        with(
          headers: {
            'Authorization'=>'Basic dXNlcjpwYXNz',
          'Connection'=>'close',
          'Host'=>'api.routexl.com',
          'User-Agent'=>'http.rb/5.1.0'
          },
          basic_auth: ['user', 'pass']
        ).
        to_return(status: 403, body: "", headers: {})

        arr = Array.new(11, location)
        expect { client.distances(arr) }.to raise_error(RouteXL::SubscriptionError)
      end

      it 'raises NoInputError when 409 is returned' do
        stub_request(:post, "https://api.routexl.com/distances").
        with(
          headers: {
            'Authorization'=>'Basic dXNlcjpwYXNz',
          'Connection'=>'close',
          'Host'=>'api.routexl.com',
          'User-Agent'=>'http.rb/5.1.0'
          },
          basic_auth: ['user', 'pass']
        ).
        to_return(status: 409, body: "", headers: {})

        arr = []
        expect {client.distances(arr) }.to raise_error(RouteXL::NoInputError)
      end
    end
  end

  describe '#distances' do
  end

  describe '#tour' do
  end
end
