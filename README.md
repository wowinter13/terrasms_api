# TerrasmsApi

Ruby client for Terrasms API | Библиотека для API провайдера Terrasms

**Table of Contents**

- [Installation](#installation)
- [Usage](#usage)
  - [Quick Demo](#quick-demo)
  - [Exceptions](#exceptions)
- [Contributing](#contributing)
- [License](#license)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'terrasms_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install terrasms_api

## Usage

### Quick demo

```ruby
require 'terrasms_api'
```

First, create client using your access token:

```ruby
client = TerrasmsApi.new(access_token: 'your.token')
```
After that simply do some request.

```ruby
# send sms
# mandatory_attributes for mostly all requests:
# - login: your login for Terrasms auth
# - target: phone or email
# - sender: public name
# - message: sms body

client.post('send', mandatory_attributes)
```

## Exceptions

```ruby
def send_sms
  client.post('send', attrs)
rescue TerrasmsApi::RequestError, TerrasmsApi::ConnectionError => e
  puts e.message, e.backtrace
end
```

Name | Description 
---|---
 `TerrasmsApi::RequestError` | Request didn't succeed
 `TerrasmsApi::ConnectionError` | Connection didn't succeed

## Testing

```
bundle exec rspec
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).