# frozen_string_literal: true

# rbs_inline: enabled

module YardToRbsInline
  module Converter
    class PrependLine < Data.define(:line_num, :content)
      # @rbs!
      #   def initialize: (line_num: Integer, content: String) -> void
      #   attr_reader line_num: Integer
      #   attr_reader content: String

      #: (Prism::Node, String) -> PrependLine
      def self.from_node_and_content(node, comment_content)
        start_line = node.location.start_line
        start_column = node.location.start_column

        line = " " * start_column + comment_content

        PrependLine.new(line_num: start_line, content: line)
      end
    end

    class AppendLineContent < Data.define(:line_num, :content)
      # @rbs!
      #   def initialize: (line_num: Integer, content: String) -> void
      #   attr_reader line_num: Integer
      #   attr_reader content: String

      #: (Prism::Node, String) -> AppendLineContent
      def self.from_node_and_content(node, comment_content)
        start_line = node.location.start_line

        AppendLineContent.new(line_num: start_line, content: " #{comment_content}")
      end
    end

    # @rbs!
    #   type mod = PrependLine | AppendLineContent

    class TextWithMod
      attr_reader :original_text #: Prism::Source

      attr_reader :mods #: Array[mod]

      #: (String) -> untyped
      def initialize(original_text)
        @original_text = original_text
        @mods = []
      end

      def modified_text #: String
        prepended_line_nums = [] #: Array[String]
        mods.each_with_object(original_text.lines.map(&:chomp)) do |mod, source_lines|
          real_line_num = mod.line_num + prepended_line_nums.map { |i| i <= mod.line_num }.length # 1-index

          case mod
          in PrependLine(content:)
            prepended_line_nums << mod.line_num
            source_lines.insert(real_line_num - 1, content)
          in AppendLineContent(content:)
            source_lines[real_line_num - 1] += content
          end
        end.join("\n") + "\n"
      end
    end
  end
end
