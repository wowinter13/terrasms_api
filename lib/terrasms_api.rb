class TerrasmsApi
  class TerrasmsApi::ConnectionError < StandardError; end
  class TerrasmsApi::RequestError < StandardError; end

  autoload :Request, 'terrasms_api/request'
  autoload :Error, 'terrasms_api/error'

  attr_reader :access_token, :options

  def initialize(access_token:, **options)
    @access_token = access_token
    @options = options
  end

  %i[get put post].each do |method|
    define_method(method) do |path, **args|
      request_object.public_send(method, path, **args)
    end
  end

  private

  def request_object
    Request.new(access_token: access_token)
  end
end
