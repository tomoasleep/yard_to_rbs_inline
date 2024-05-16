# rbs_inline: enabled

class Code
  # @return [String]
  attr_reader :source #:: String

  # @param source [String]
  #:: (String source) -> untyped
  def initialize(source)
    @source = source
  end

  # @param new_source [String]
  # @return [Code]
  #:: (String new_source) -> Code
  def rewrite(new_source)
    @source = new_source

    self
  end

  # @param recover [Boolean].
  # @return [Array<Token>]
  #:: (?recover: bool) -> Array[Token]
  def tokenize(recover: false)
    parser.tokenize(source, recover: recover)
  end
end
