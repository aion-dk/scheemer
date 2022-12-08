# frozen_string_literal: true

require_relative "./extensions/string"

module Scheemer
  # This handles the conversion from the HTTP linguo (camelCase)
  # to Ruby linguo (snake_case), triggers the children's predefined
  # validations and provides accessors for the top level properties
  # of the incoming hash.
  module Params
    using Extensions::CaseModifier

    def initialize(params, data = {})
      @params = params

      validate!(data.to_h) if respond_to?(:validate!)
    end

    def to_h
      @params.to_h.transform_keys { |key| key.to_s.underscore }
    end

    def method_missing(name, *args, &block)
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
