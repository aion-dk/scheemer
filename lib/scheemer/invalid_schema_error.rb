module Scheemer
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
