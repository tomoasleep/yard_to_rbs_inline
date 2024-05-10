# frozen_string_literal: true

require_relative "yard_to_rbs_inline/version"

module YardToRbsInline
  class Error < StandardError; end
end

require_relative "yard_to_rbs_inline/cli"
require_relative "yard_to_rbs_inline/converter"
require_relative "yard_to_rbs_inline/yard_type"
