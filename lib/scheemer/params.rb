require "dry-schema"

require_relative "./invalid_schema_error"
require_relative "./extensions/string"

module Scheemer
  # This handles the conversion from the HTTP linguo (camelCase)
  # to Ruby linguo (snake_case), triggers the children's predefined
  # validations and provides accessors for the top level properties
  # of the incoming hash.
  class Params
    using Extensions::CaseModifier

    class << self
      def schema(&)
        @_schema ||= ::Dry::Schema.Params do
          instance_eval(&)
        end
      end

      def validate!(params)
        schema.call(params).tap do |result|
          next if result.success?

          raise InvalidSchemaError, result.messages.to_h
        end
      end
    end

    def initialize(params)
      all_params = (params.respond_to?(:permit!) ? params.permit! : params).to_h
      permitted = self.class.validate!(all_params)

      root_node = permitted.to_h.values.first

      @params = root_node

      validate! if respond_to?(:validate!)
    end

    def to_h
      @params.to_h.transform_keys { |key| key.to_s.underscore }
    end

    def method_missing(name, *args, &)
      key_name = name.to_sym.camelcase
      return @params.fetch(key_name) if @params.key?(key_name)

      super
    end

    def respond_to_missing?(name, include_private = false)
      key_name = name.camelcase
      @params.key?(key_name) || super
    end
  end
end
