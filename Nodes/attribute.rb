class Attribute < AbstractNode
  def key
    return @key
  end
  def key=key
    @key = key
  end

  def value
    return @value
  end
  def value=value
    @value=value
  end

  def initialize(key, value)
    @key = key
    @value = value
  end
end