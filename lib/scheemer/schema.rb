# frozen_string_literal: true

require "dry-schema"

Dry::Schema.load_extensions(:hints)

require_relative "./errors"

module Scheemer
  class Schema
    module DSL
      def schema(&block)
        @schema ||= Schema.new(&block)
      end

      def validate_schema!(params)
        @schema ||
          (raise NotImplementedError, "Expected `schema { ... }` to have been specified")

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
