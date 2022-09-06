# frozen_string_literal: true

module Scheemer
  class Error < StandardError; end

  class DuplicateSchemaError < Error
    def message
      <<~MSG.squish
        The schema has already been defined.
        Search your code, you know it to be true."
      MSG
    end
  end

  class InvalidSchemaError < Error
    def message
      "#{title}: #{super}"
    end

    private

    def title
      "The submitted request does not satisfy the following requirements"
    end
  end
end
