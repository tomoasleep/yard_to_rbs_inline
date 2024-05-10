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

  # @param recover [Boolean].
  # @return [Array<Token>]
  def tokenize(recover: false)
    parser.tokenize(source, recover: recover)
  end
end
