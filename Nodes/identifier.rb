class Identifier
  def name
    return @name
  end
  def name=name
    @name=name
  end

  def index
    return @index
  end
  def index=index
    @index = index
  end

  def length
    return @length
  end
  def length=length
    @length=length
  end

  def type
    return @type
  end
  def type=type
    @type=type
  end

  def initialize(name, type, index, length)
    @name = name
    @type = type
    @index = index
    @length = length
  end
end