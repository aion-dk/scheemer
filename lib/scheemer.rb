# frozen_string_literal: true

module Scheemer
  class Error < StandardError; end

  module DSL
    def self.extended(entity)
      entity.extend(Schema::DSL)
      entity.include(Params)
      entity.include(InstanceMethods)
    end
  end

  module InstanceMethods
    def initialize(params)
      all_params = (params.respond_to?(:permit!) ? params.permit! : params).to_h
      permitted = self.class.validate!(all_params)

      root_node = permitted.to_h.values.first

      super root_node
    end
  end
end

require_relative "scheemer/params"
require_relative "scheemer/schema"
require_relative "scheemer/version"
