# rbs_inline: enabled

require_relative 'subscriptable'

module YardToRbsInline
  module Converter
    class CodeVisitor < Prism::Visitor
      include Subscriptable

      # @!rbs
      #   type mod = PrependLine | AppendLineContent

      attr_reader :source #:: Prism::Source

      attr_reader :comments #:: Array[Prism::InlineComment]

      attr_reader :text_with_mod #:: TextWithMod

      #:: (source: Prism::Source, comments: Array[Prism::InlineComment]) -> untyped
      def initialize(source:, comments:)
        @source = source
        @comments = comments
        @text_with_mod = TextWithMod.new(source.source)
      end

      #:: (Prism::CallNode) -> void
      def visit_call_node(node)
        parse_annotation = lambda do
          annotation_comments = annotations_for(node)
          annotation_strs = annotation_comments.map(&method(:source_for_comment))
          annotation_strs.map(&:chomp).join("\n")
        end

        case node.name.to_sym
        when :attr_reader
          annotation = parse_annotation.call

          unless annotation.match?(/^\s*#(::|\s*@rbs)/)
            docstring = YARD::DocstringParser.new.parse(annotation.gsub(/^\s*#\s*/, '')).to_docstring

            sig = capture_error_to_write_comment(node) { build_return_sig(docstring) }
            text_with_mod.mods << AppendLineContent.from_node_and_content(node, "#:: #{sig}")
          end
        end

        super
      end

      #:: (Prism::DefNode) -> void
      def visit_def_node(node)
        annotation_comments = annotations_for(node)
        annotation_strs = annotation_comments.map(&method(:source_for_comment))
        annotation = annotation_strs.map(&:chomp).join("\n")

        unless annotation.match?(/^\s*#(::|\s*@rbs)/)
          docstring = YARD::DocstringParser.new.parse(annotation.gsub(/^\s*#\s*/, '')).to_docstring

          sig = capture_error_to_write_comment(node) { build_signature(node.parameters, docstring) }

          text_with_mod.mods << PrependLine.from_node_and_content(node, "#:: #{sig}")

          # STDERR.puts "#{node.name_loc.inspect} #{node.name}: #{sig}"
        end

        super
      end

      private

      #:: (YARD::Docstring) -> String
      def build_return_sig(docstring)
        return_tag = docstring.tag("return") #:: YARD::Tags::Tag | nil

        if return_tag&.types
          convert_types(return_tag.types)
        else
          "untyped"
        end
      end

      #:: (Prism::ParametersNode | nil, YARD::Docstring) -> String
      def build_signature(params, docstring)
        params_sig = build_params_signature(params, docstring)
        return_sig = build_return_sig(docstring)

        "(#{params_sig}) -> #{return_sig}"
      end

      #:: (Prism::ParametersNode | nil, YARD::Docstring) -> String
      def build_params_signature(params, docstring)
        return "" unless params

        param_tags = docstring.tags("param") #:: Array[YARD::Tags::Tag]

        find_tag = proc do |name|
          if name
            param_tags.find { |tag| tag.name == name.to_s }
          else
            nil
          end
        end

        param_sigs = []
        params.requireds.each do |param|
          tag = find_tag.call(param.name)

          if tag&.types
            param_sigs << "#{convert_types(tag.types)} #{param.name}"
          else
            param_sigs << "untyped #{param.name}"
          end
        end

        params.optionals.each do |param|
          tag = find_tag.call(param.name)

          if tag&.types
            param_sigs << "?#{convert_types(tag.types)} #{param.name}"
          else
            param_sigs << "?untyped #{param.name}"
          end
        end

        if (param = params.rest)
          tag = find_tag.call(param.name)

          if tag&.types
            param_sigs << "*#{convert_types(tag.types)} #{param.name}"
          else
            param_sigs << "*untyped #{param.name}"
          end
        end

        params.posts.each do |param|
          tag = find_tag.call(param.name)

          if tag&.types
            param_sigs << "#{convert_types(tag.types)} #{param.name}"
          else
            param_sigs << "untyped #{param.name}"
          end
        end

        params.keywords.each do |param|
          tag = find_tag.call(param.name)

          prefix =
            case param.type
            when :required_keyword_parameter_node
              ""
            when :optional_keyword_parameter_node
              "?"
            end

          if tag && tag.types
            param_sigs << "#{prefix}#{param.name}: #{convert_types(tag.types)}"
          else
            param_sigs << "#{prefix}#{param.name}: untyped"
          end
        end

        if (param = params.keyword_rest)
          tag = find_tag.call(param.name)

          if tag&.types
            param_sigs << "**#{convert_types(tag.types)} #{param.name}"
          else
            param_sigs << "**untyped #{param.name}"
          end
        end

        # Remove trailing spaces for unnamed params
        param_sigs.map(&:strip).join(", ")
      end

      #:: (Array[String], node: Prism::Node) -> String
      def convert_types(yard_type_literals)
        new_types = yard_type_literals.map do |literal|
          yard_type = YardToRbsInline::YardType::Parser.new.parse(literal)
          convert_yard_type(yard_type)
        rescue Racc::ParseError, Yoda::Parsing::YardType::Scanner::ScanError => e
          # STDERR.puts "Cannot parse #{literal}: #{e}"
          emit_error_message("Cannot parse #{literal}: #{e}")

          'untyped'
        end.uniq

        new_types.empty? ? 'untyped' : new_types.join(' | ')
      end

      #:: (YardToRbsInline::YardType::Ast::node, node: Prism::Node) -> String
      def convert_yard_type(yard_type)
        case yard_type
        in YardType::Ast::Type(name:)
          case name
          when "Object"
            "untyped"
          when "Boolean", "TrueClass", "FalseClass", "boolean", "true", "false"
            "bool"
          else
            name
          end
        in YardType::Ast::DuckType(name:)
          case name
          when "each"
            "Enumerable"
          else
            emit_error_message("Unknown duck type: ##{name}")
            "untyped"
          end
        in YardType::Ast::LiteralType(content:)
          content
        in YardType::Ast::GenericType(container_type:, types:)
          container_sig = container_type ? convert_yard_type(container_type) : "Array"
          "#{container_sig}[#{types.map(&method(:convert_yard_type)).join(' | ')}]"
        in YardType::Ast::TupleType(container_type:, types:)
          container_sig = container_type ? convert_yard_type(container_type) : "Array"
          "#{container_sig} & [#{types.map(&method(:convert_yard_type)).join(', ')}]"
        in YardType::Ast::HashType(container_type:, type_pair: [key_type, value_type])
          container_sig = container_type ? convert_yard_type(container_type) : "Hash"
          "#{container_sig}[#{convert_yard_type(key_type)}, #{convert_yard_type(value_type)}]"
        in YardType::Ast::UnionType(types:)
          types.map(&method(:convert_yard_type)).join(' | ')
        end
      end

      #:: (Prism::Node) -> Integer
      def start_line_of_node(node)
        gather_comment_targets = proc do |l|
          if l.respond_to?(:comment_targets)
            l.comment_targets.flat_map { |t| gather_comment_targets.call(t) }
          else
            [l]
          end
        end

        gather_comment_targets.call(node).map(&:start_line).min || 0
      end

      #:: (Prism::Node) -> Array[Prism::InlineComment]
      def annotations_for(node)
        start_line = start_line_of_node(node)

        matched_comments = []
        matched_comments += comments_by_line[start_line] if comments_by_line[start_line]

        (start_line - 1).downto(1) do |line|
          current_comments = comments_by_line[line]
          if current_comments
            matched_comments += current_comments
          else
            break
          end
        end

        matched_comments
      end

      #:: (Prism::InlineComment) -> String
      def source_for_comment(comment)
        source.slice(comment.location.start_offset, comment.location.length)
      end

      #:: () -> Hash[Integer, Array[Prism::InlineComment]]
      def comments_by_line
        @comments_by_line ||= comments.group_by { |comment| comment.location.start_line }
      end
    end
  end
end
