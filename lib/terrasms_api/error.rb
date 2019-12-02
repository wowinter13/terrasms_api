class TerrasmsApi
  class Error
    def self.call
      yield
    rescue RestClient::Exception, RestClient::ExceptionWithResponse => e
      raise TerrasmsApi::RequestError, e
    rescue SocketError => e
      raise TerrasmsApi::ConnectionError, e
    end
  end
end