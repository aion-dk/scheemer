module Scheemer
  module Extensions
    module CaseModifier
      refine Symbol do
        def camelcase
          first, *rest = to_s.split("_")
          [first, rest.collect(&:capitalize)].join.to_sym
        end
      end
    end
  end
end
