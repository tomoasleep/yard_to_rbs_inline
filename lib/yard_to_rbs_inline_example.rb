# frozen_string_literal: true

require_relative "yard_to_rbs_inline_example/version"

module YardToRbsInlineExample
  class Error < StandardError; end
end

require_relative "yard_to_rbs_inline_example/cli"
require_relative "yard_to_rbs_inline_example/converter"
require_relative "yard_to_rbs_inline_example/yard_type"
