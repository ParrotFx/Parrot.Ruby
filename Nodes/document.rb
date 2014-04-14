class Document
  def errors
    return @errors
  end
  def errors= errors
    @errors = errors
  end

  def children
    return @children
  end
  def children= children
    @children = children
  end

  def initialize(document = nil, statement = nil)
    if document != nil
      @children = document.children
    else
      @children = Array.new
    end

    if statement != nil
      @children.push(statement)
    end

    @errors = Array.new
  end
end