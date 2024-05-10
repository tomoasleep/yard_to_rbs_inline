require 'prism'
require 'yard'

module YardToRbsInline
  module Converter
    def self.convert(file, dry_run: false)
      result = Prism.parse_file(file)

      visitor = CodeVisitor.new(source: result.source, comments: result.comments)
      unless result.source.source.match(/^# rbs_inline:/)
        visitor.text_with_mod.mods << PrependLine.new(line_num: 1, content: "# rbs_inline: enabled")
        visitor.text_with_mod.mods << PrependLine.new(line_num: 1, content: "")
      end

      result.value.accept(visitor)

      if dry_run
        puts visitor.text_with_mod.modified_text
      else
        File.write(file, visitor.text_with_mod.modified_text)
      end
    end
  end
end

require_relative "converter/code_visitor"
require_relative "converter/subscriptable"
require_relative "converter/text_with_mod"
