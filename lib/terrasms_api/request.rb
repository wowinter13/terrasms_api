require 'digest'
require 'rest-client'

class TerrasmsApi
  class Request
    API_BASE_URL = 'https://auth.terasms.ru/outbox'.freeze

    attr_reader :access_token

    def initialize(access_token:)
      @access_token = access_token
    end

    %i[get put post].each do |method|
      define_method(method) do |path, **args|
        response = with_handled_errors do
          RestClient.public_send(
            method,
            build_full_url(path),
            body_params(args),
            headers
          )
        end

        parsed_body(response)
      end
    end

    private

    def build_full_url(path)
      [API_BASE_URL, path].join('/')
    end

    def body_params(args = {})
      md5_sign = Digest::MD5.hexdigest([
        RestClient::Utils.encode_query_string(args),
        access_token
      ].join(''))

      args.merge(sign: md5_sign)
    end

    def headers
      {}
    end

    def with_handled_errors
      TerrasmsApi::Error.call { yield }
    end

    def parsed_body(response)
      JSON.parse(response.body)
    rescue JSON::ParserError
      response.body
    end
  end
end