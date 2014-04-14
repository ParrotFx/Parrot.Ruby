class Parameter < AbstractNode
  def value
    return @value
  end

  def calculated_value
    return @calculated_value
  end
  def calculated_value=value
    @calculated_value = value
  end

  def initialize(value)
    @value = value
    @calculated_value = value
  end
end