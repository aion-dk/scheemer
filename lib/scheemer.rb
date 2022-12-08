# frozen_string_literal: true

module Scheemer
  module DSL
    def self.extended(entity)
      entity.extend(Schema::DSL)
      entity.include(Params)
      entity.include(InstanceMethods)
    end
  end

  module InstanceMethods
    def initialize(params, extra_context = {})
      all_params = (params.respond_to?(:permit!) ? params.permit! : params).to_h
      permitted = self.class.validate_schema!(all_params)

      @extra_context = extra_context.to_h
      root_node = permitted.to_h.values.first

      super root_node
    end

    private

    def respond_to?(name, include_private = false)
      @extra_context.key?(name) || super
    end

    def method_missing(name, *args, &block)
      return @extra_context[name] if @extra_context.key?(name)

      super
    end
  end
end

require_relative "scheemer/errors"
require_relative "scheemer/params"
require_relative "scheemer/schema"
require_relative "scheemer/version"
