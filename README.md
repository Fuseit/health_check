# health_check
[![Build Status](https://circleci.com/gh/Fuseit/health_check/tree/master.svg?style=shield&circle-token=44d4f019603fa36a3bd6ecdd68a4a3af53e276b9)](https://circleci.com/gh/Fuseit/health_check/tree/master)

A gem that provides an extensible rack-based health endpoint for applications and the resources they depend on. 


## Features
Currently supports checks for the following dependencies: 

* HTTP (Rack)
* Sidekiq
* Redis
* Active Record Database 
* Elasticsearch 
* Faye

## Set up

Add the `health_check` gem to your Gemfile. 

### Rack Applications

Add the following to `config.ru` 


```ruby
# config.ru
require 'health_check'

use Rack::HealthCheck
```

### Rails Applications

Add the following to `config/application.rb` 

```ruby
# config/application.rb
# ...
config.middleware.use Rack::HealthCheck
# ...
```

### Configuration

By default the only check that is performed is to get an `http` response, addional checks are configured by passing them as arguments, for example: 

```ruby
# application.rb
config.middleware.use Rack::HealthCheck, checks: %i[http active_record]
```


Some checks (like `elasticsearch`) require additional paramaters for example: 

```ruby
# config.ru
use Rack::HealthCheck, checks: [
  :http, [:elasticsearch, { server_url: Figaro.env.elasticsearch_url! }]
]
```

## Usage 

The `/health` endpoint is used to get the health check information, for instance, calling 

```
http://localhost/health
```

returns 

```
{
  "http": {
    "status": "OK"
  },
  "active_record": {
    "status": "OK",
    "value": "true"
  }
}
```

Check results are listed individually to aid in debugging and provide for the cofiguration of specific alerts. 

## Tests

The gem contains its own set of unit tests for the various checks, they can be executed by checking out the repo and running `bundle exec rspec` in the root directory of the gem. 

## Dependencies 

The only dependency for using the gem is to have `rack` installed. 

For development the following additional dependencies are needed: 

```
'bundler', '~> 1.7'
'rake', '~> 10.0'
'rspec', '~> 3.2.0'
'rack-test', '~> 0.6.3'
```
