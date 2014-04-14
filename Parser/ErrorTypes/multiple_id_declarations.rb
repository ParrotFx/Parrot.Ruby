class MultipleIdDeclarations < ParserError
  def id
    return @id
  end

  def initialize(id)
    @id = id
  end
end