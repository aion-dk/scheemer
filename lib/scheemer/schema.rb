require "dry-schema"

Dry::Schema.load_extensions(:hints)

require_relative "./invalid_schema_error"

module Scheemer
  class Schema
    module DSL
      def schema(&block)
        @schema ||= Schema.new(&block)
      end

      def validate!(params)
        @schema ||
          (fail NotImplementedError, "Expected `schema { ... }` to have been specified")

        @schema.validate!(params)
      end
    end

    def initialize(&block)
      @definitions = ::Dry::Schema.Params do
        instance_eval(&block)
      end
    end

    def validate!(params)
      @definitions.call(params).tap do |result|
        next if result.success?

        raise InvalidSchemaError, result.messages.to_h
      end
    end
  end
end
