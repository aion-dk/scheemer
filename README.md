# Scheemer

Scheemer uses [Dry::Schema](https://github.com/dry-rb/dry-schema) to
enable us to write consistent looking structural parameter validation
and data accessing on our services.

## Usage

### Using the Scheemer

Scheemer::DSL ties together the parameters key translation and
structural validation.

```ruby
klass = Class.new do
  extend Scheemer::DSL

  schema do
    required(:root).hash do
      required(:someValue).filled(:string)
    end
  end
end

record = klass.new({ root: { someValue: "testing" } })
record.some_value # => "testing"
```

### Using Scheemer::Params

Scheemer::Params handles the parameters key translation.

```ruby
klass = Class.new do
  include Scheemer::Params

  def initialize(...)
    super

    ...
  end
end

record = klass.new({ someValue: "testing" })
record.some_value # => "testing"
```

### Using Scheemer::Schema

Scheemer::Schema::DSL handles the structural validation.

```ruby
klass = Class.new do
  extend Scheemer::Schema::DSL

  schema do
    required(:name).filled(:string)
  end

  attr_reader :contents

  def initialize(params)
    @contents = self.class.validate_schema!(params)
  end
end

klass.new({ name: 1 }) # => Error:'{:name=>['must be a string"]}"
```

## Development

```bash
$ docker-compose run scheemer /bin/sh
$ docker-compose run scheemer rspec
$ docker-compose build scheemer
```

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
$ bundle add aion-dk/scheemer
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
$ gem install aion-dk/scheemer
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
