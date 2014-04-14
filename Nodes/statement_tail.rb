class StatementTail < AbstractNode
  def parameters
    return @parameters
  end
  def parameters= parameters
    @parameters = parameters
  end

  def attributes
    return @attributes
  end
  def attributes= attributes
    @attributes = attributes
  end

  def children
    return @children
  end
  def children= children
    @children = children
  end

  def initialize(children = nil, attributes = nil, parameters = nil)
    @children = children
    @attributes = attributes
    @parameters = parameters
  end
end