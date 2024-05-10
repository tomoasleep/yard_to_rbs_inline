# rbs_inline: enabled

require 'strscan'

module YardToRbsInlineExample::YardType
  class Scanner
    class ScanError < StandardError; end

    Token = Struct.new(:kind, :content, keyword_init: true)

    TOKEN_PATTERNS = {
      generic_start: /</,
      generic_end: />/,
      tuple_start: /\(/,
      tuple_end: /\)/,
      duck_symbol: /#/,
      separator: /[,;]/,
      arrow: /\=>/,
      hash_start: /\{/,
      hash_end: /\}/,
      name: /(::|\w)+/,
      symbol: /:\w+/,
      string: [/\"[^"]*\"/, /\'[^']*\'/],
      integer: /\d+/,
      spaces: /\s+/,
    }

    attr_reader :text #:: String

    #:: (String text) -> untyped
    def initialize(text)
      @text = text
    end

    #:: () -> Array[[Symbol | bool, String]]
    def to_racc_tokens
      tokens.map { |token| [token.kind.to_s.upcase.to_sym, token.content] } + [[false, "EOS"]]
    end

    #:: () -> Array[Token]
    def tokens
      @tokens ||= begin
        scanner = StringScanner.new(text)
        tokens = []

        scan_step = lambda do
          TOKEN_PATTERNS.each do |kind, pattern_or_patterns|
            Array(pattern_or_patterns).each do |pattern|
              if (matched = scanner.scan(pattern))
                tokens << Token.new(kind: kind, content: matched) unless kind == :spaces
                return
              end
            end
          end

          raise ScanError, "Unknown keyword #{scanner.rest} (in #{text})"
        end

        until scanner.eos? do
          scan_step.call
        end

        tokens
      end
    end
  end


end
