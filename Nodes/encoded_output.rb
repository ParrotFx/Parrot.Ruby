class EncodedOutput < StringLiteral
  def variable_name
    return @variable_name
  end
  def variable_name=variable_name
    @variable_name = variable_name
  end

  def initialize(variable_name, tail = nil)
    super('"@' + variable_name + '"', tail)
  end
end