# frozen_string_literal: true

require "dry-schema"
require "json-schema"

Dry::Schema.load_extensions(:hints, :json_schema)

require_relative "./errors"

module Scheemer
  class Schema
    module DSL
      def schema(&)
        @schema ||= Schema.new(&)
      end

      def validate_schema(params)
        check_schema_exists!

        @schema.validate(params)
      end

      def validate_schema!(params)
        check_schema_exists!

        @schema.validate!(params)
      end

      def json_schema
        @schema.json_schema
      end

      private

      def check_schema_exists!
        return if @schema

        raise NotImplementedError, "Expected `schema { ... }` to have been specified"
      end
    end

    def initialize(&)
      @definitions = ::Dry::Schema.Params do
        config.validate_keys = false

        instance_eval(&)
      end
    end

    def validate(params)
      @definitions.call(params)
    end

    def validate!(params)
      return params if JSON::Validator.validate(json_schema, params)

      validate(params).tap do |result|
        next if result.success?

        raise InvalidSchemaError, result.messages.to_h
      end
    end

    def json_schema
      @definitions.json_schema
    end
  end
end
