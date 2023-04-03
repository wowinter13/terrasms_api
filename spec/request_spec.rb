require 'terrasms_api'
require 'spec_helper'

describe TerrasmsApi::Request do
  let(:access_token) { 'SomeCoolToken' }
  let(:request) { TerrasmsApi::Request.new(access_token: access_token) }

  describe 'dynamically generates REST-methods' do
    it { expect(request).to respond_to(:get) }
    it { expect(request).to respond_to(:post) }
    it { expect(request).to respond_to(:put) }
  end

  describe 'actually makes requests' do
    let(:success_result) { File.read("spec/fixtures/outbox_success_send.json") }

    it 'returns parsed json' do
      stub_request(:post, 'https://auth.terasms.ru/outbox/send')
        .to_return(body: success_result)

      expect(request.post('send', q: {}))
        .to include_json JSON.parse(success_result)
    end
  end

  describe 'does a request with correct params' do
    before do
      stub_request(:any, /.*auth.terasms.ru.*/)
      
      allow(RestClient).to receive(:post).and_return(correct_response)
    end

    let(:correct_response) do
      OpenStruct.new(code: 200, headers: {}, body: '')
    end

    let(:options) do
      {
        login: 'cool-login',
        target: '88005553535',
        sender: 'RubyGems',
        message: '1212%:/'
      }
    end

    let(:correct_md5) { Hash[:sign, '7a4f96fc65e5fa3d330122ece736e901'] }

    subject { request.post('send', options) }

    it 'has a correct MD5 hash and all parameters' do
      expect(RestClient)
        .to receive(:post)
        .with(anything, options.merge(correct_md5), anything)

      subject
    end
  end

  describe 'internal error' do
    before do
      stub_request(:any, 'https://auth.terasms.ru/outbox/send')
        .to_return(body: internal_error_code.to_s)
    end

    let(:internal_error_code) { -rand(100) - 1 }

    let(:options) do
      {
        login: 'cool-login',
        target: '88005553535',
        sender: 'RubyGems',
        message: '1212'
      }
    end

    subject { request.post('send', options) }

    it 'raise internal_error' do
      expect { subject }.to(
        raise_error(
          "Internal error: #{internal_error_code} see https://terasms.ru/documentation/api/http/errors"
        )
      )
    end
  end
end
