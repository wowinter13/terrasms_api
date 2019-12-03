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
        message: '1212'
      }
    end

    let(:correct_md5) { Hash[:sign, 'c3612425f27d62c9b5c8f51cdd696355'] }

    subject { request.post('send', options) }

    it 'has a correct MD5 hash and all parameters' do
      expect(RestClient)
        .to receive(:post)
        .with(anything, options.merge(correct_md5), anything)

      subject
    end
  end
end
