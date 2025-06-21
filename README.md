# Lt::Google::Api

[![Maintainability](https://api.codeclimate.com/v1/badges/14c045858a1bdf132c3f/maintainability)](https://codeclimate.com/github/learningtapestry/lt-google-api/maintainability)
[![Codeship Status for learningtapestry/lt-google-api](https://app.codeship.com/projects/c23dbbf0-26f8-0137-d557-666da1a91ebd/status?branch=master)](https://app.codeship.com/projects/330486)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lt-google-api'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install lt-google-api
```

## Usage

| Name                        | Description |
|-----------------------------|-------------|
| GOOGLE_OAUTH2_CLIENT_ID     |             |
| GOOGLE_OAUTH2_CLIENT_SECRET |             |

## Development

```shell
docker buildx build --platform linux/arm64/v8,linux/amd64 -t learningtapestry/lt-google-api:legacy --push .
```

### Type checking

Install existing collections:

```shell
rbs collection install
```

Validate installation

```shell
rbs validate
```

Check types

```shell
steep check
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/learningtapestry/lt-google-api.

## License
The gem is available as open source under the terms of the [Apache License](https://github.com/learningtapestry/lcms-engine/blob/master/LICENSE).
