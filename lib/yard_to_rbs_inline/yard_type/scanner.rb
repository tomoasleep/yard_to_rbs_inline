# frozen_string_literal: true

# rbs_inline: enabled

require "strscan"

module YardToRbsInline
  module YardType
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
        arrow: /=>/,
        hash_start: /\{/,
        hash_end: /\}/,
        name: /(::|\w)+/,
        symbol: /:\w+/,
        string: [/"[^"]*"/, /'[^']*'/],
        integer: /\d+/,
        spaces: /\s+/
      }.freeze

      attr_reader :text #: String

      #: (String text) -> untyped
      def initialize(text)
        @text = text
      end

      #: () -> Array[[Symbol | boolish, String]]
      def to_racc_tokens
        tokens.map do |token| #$ [Symbol | bool, String]
          [token.kind.to_s.upcase.to_sym, token.content]
        end + [
          [false, "EOS"] #: [bool, String]
        ]
      end

      # @rbs @tokens: Array[Token]?

      #: () -> Array[Token]
      def tokens
        @tokens ||= begin
          scanner = StringScanner.new(text)
          tokens = [] #: Array[Token]

          scan_step = lambda do
            TOKEN_PATTERNS.each do |kind, pattern_or_patterns|
              Array(pattern_or_patterns).each do |pattern|
                next unless (matched = scanner.scan(pattern))

                tokens << Token.new(kind: kind, content: matched) unless kind == :spaces
                # For now, steep parse this as a return of the whole method
                return # steep:ignore
              end
            end

            raise ScanError, "Unknown keyword #{scanner.rest} (in #{text})"
          end

          scan_step.call until scanner.eos?

          tokens
        end
      end
    end
  end
end
