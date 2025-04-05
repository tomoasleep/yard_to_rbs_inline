# frozen_string_literal: true

# rbs_inline: enabled

module YardToRbsInline
  module YardType
    require_relative "yard_type/ast"
    require_relative "yard_type/parser"
    require_relative "yard_type/scanner"
  end
end
