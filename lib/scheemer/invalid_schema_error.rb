class InvalidSchemaError < StandardError
  def message
    "#{title}: #{super}"
  end

  private

  def title
    "The submitted request does not satisfy the following requirements"
  end
end
