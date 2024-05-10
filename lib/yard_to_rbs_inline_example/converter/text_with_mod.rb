# rbs_inline: enabled

module YardToRbsInlineExample
  module Converter
    PrependLine = Data.define(:line_num, :content) do
      #:: (Prism::Node, String) -> PrependLine
      def self.from_node_and_content(node, comment_content)
        start_line = node.location.start_line
        start_column = node.location.start_column

        line = ' ' * start_column + comment_content

        PrependLine.new(line_num: start_line, content: line)
      end
    end

    AppendLineContent = Data.define(:line_num, :content) do
      #:: (Prism::Node, String) -> PrependLine
      def self.from_node_and_content(node, comment_content)
        start_line = node.location.start_line

        AppendLineContent.new(line_num: start_line, content: ' ' + comment_content)
      end
    end

    class TextWithMod
      attr_reader :original_text #:: Prism::Source

      attr_reader :mods #:: Array[mod]

      #:: (String) -> untyped
      def initialize(original_text)
        @original_text = original_text
        @mods = []
      end

      #:: () -> String
      def modified_text
        prepended_line_nums = []
        mods.reduce(original_text.lines(chomp: true)) do |source_lines, mod|
          real_line_num = mod.line_num + prepended_line_nums.map { |i| i <= mod.line_num }.length # 1-index

          case mod
          in PrependLine(content:)
            prepended_line_nums << mod.line_num
            source_lines.insert(real_line_num - 1, content)
          in AppendLineContent(content:)
            source_lines[real_line_num - 1] += content
          end

          source_lines
        end.join("\n") + "\n"
      end
    end
  end
end
