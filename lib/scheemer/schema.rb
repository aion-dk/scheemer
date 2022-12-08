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

      def validate_schema(params)
        check_schema_exists!

        @schema.validate(params)
      end

      def validate_schema!(params)
        check_schema_exists!

        @schema.validate!(params)
      end

      private

      def check_schema_exists!
        return if @schema

        raise NotImplementedError, "Expected `schema { ... }` to have been specified"
      end
    end

    def initialize(&block)
      @definitions = ::Dry::Schema.Params do
        instance_eval(&block)
      end
    end

    def validate(params)
      @definitions.call(params)
    end

    def validate!(params)
      validate(params).tap do |result|
        next if result.success?

        raise InvalidSchemaError, result.messages.to_h
      end
    end
  end
end
