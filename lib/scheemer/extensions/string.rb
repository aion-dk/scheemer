# frozen_string_literal: true

module Scheemer
  module Extensions
    module CaseModifier
      CAMELCASER = lambda do |value|
        first, *rest = value.to_s.split("_")
        [first, rest.collect(&:capitalize)].join
      end
      UNDERSCORER = lambda do |value|
        value.gsub(/::/, '/').
          gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          tr("-", "_").
          downcase
      end

      refine Symbol do
        def camelcase
          CAMELCASER.(self).to_sym
        end

        def underscore
          UNDERSCORER.(self).to_sym
        end
      end

      refine String do
        def camelcase
          CAMELCASER.(self)
        end

        def underscore
          UNDERSCORER.(self)
        end
      end
    end
  end
end
