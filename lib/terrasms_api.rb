require "terrasms_api/version"

module TerrasmsApi
  class TerrasmsApi::ConnectionError < StandardError;
  class TerrasmsApi::RequestError < StandardError;

  autoload :Request, 'terrasms_api/request'
  autoload :Exception, 'terrasms_api/exception'
  autoload :Client, 'terrasms_api/exception'

  attr_reader :access_token, :options

  def initialize(access_token: nil, options={})
    @access_token = access_token
    @options = options.to_h.deep_symbolize_keys
  end

  %i[get put post].each do |method|
    define_method(method) do |path, **args|
      request_object.method(path, args)
    end
  end

  private

  def request_object
    Request.new(access_token: access_token)
  end
end
