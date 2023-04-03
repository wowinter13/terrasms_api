class TerrasmsApi
  class Error
    def self.call
      result = yield
      if result.to_i&.negative?
        raise "Internal error: #{result} see https://terasms.ru/documentation/api/http/errors"
      else
        result
      end
    rescue RestClient::Exception, RestClient::ExceptionWithResponse => e
      raise TerrasmsApi::RequestError, e
    rescue SocketError => e
      raise TerrasmsApi::ConnectionError, e
    end
  end
end
