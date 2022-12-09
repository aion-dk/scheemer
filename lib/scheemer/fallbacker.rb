require_relative "./extensions/hash"

module Scheemer
  module Fallbacker
    extend self

    using Extensions::Bury

    def apply(params, fallbacks)
      cloned_params = params.dup

      fallbacks.each do |(path, value)|
        keys = path.to_s.split(".").map(&:to_sym)

        cloned_params.bury(*keys, value) unless has_deep_key?(params, keys)
      end

      cloned_params
    end

    private

    def has_deep_key?(hash, keys)
      return false if keys.one? || keys.empty?

      parent_path = keys[0...-1]

      !!hash.dig(*parent_path)&.key?(keys.last)
    end
  end
end
