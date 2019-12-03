require 'terrasms_api'
require 'spec_helper'

describe TerrasmsApi do
  let(:access_token) { 'SomeCoolToken' }
  subject { TerrasmsApi.new(access_token) }

  describe 'dynamically generates REST-methods' do
    it { expect(subject).to respond_to(:get) }
    it { expect(subject).to respond_to(:post) }
    it { expect(subject).to respond_to(:put) }
  end
end
