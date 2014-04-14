class StringLiteralPart
  def data
    return @data
  end
  def type
    return @type
  end
  def length
    return @length
  end
  def index
    return @index
  end

  def initialize(type, data, index)
    @type = type
    @data = data
    @index = index
    @length = data.length
  end
end