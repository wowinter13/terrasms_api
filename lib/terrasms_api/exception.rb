module TerrasmsApi
  class Exception

    def self.call(&block)
      response = yield
      response
    rescue RestClient::Exception, RestClient::ExceptionWithResponse => e
      raise TerrasmsApi::RequestError, e
    rescue SocketError => e
      raise TerrasmsApi::ConnectionError, e
    end
  end
end