class Code
  # @return [String]
  attr_reader :source

  # @param source [String]
  def initialize(source)
    @source = source
  end

  # @param source [String]
  # @return [Code]
  def rewrite(new_source)
    @source = new_source

    self
  end
end
