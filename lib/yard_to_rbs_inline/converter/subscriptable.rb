# frozen_string_literal: true

# rbs_inline: enabled

module YardToRbsInline
  module Converter
    # @rbs!
    #   interface _TextWithModContainer
    #     def text_with_mod: () -> TextWithMod
    #   end

    # @rbs module-self _TextWithModContainer
    module Subscriptable
      # @rbs!
      #   type subscriber = ^(String) -> void

      #: (String) -> void
      def emit_error_message(error_message)
        (@subscribers || []).each { |subscriber| subscriber.call(error_message) }
      end

      # @rbs @subscribers: Array[subscriber]

      #: [X] (subscriber) { () -> X } -> X
      def capture_error_message(subscriber)
        @subscribers ||= [] #: Array[subscriber]
        @subscribers.push(subscriber)
        yield
      ensure
        @subscribers.pop
      end

      #: (Prism::Node) -> subscriber
      def subscriber_to_prepend_error(node)
        lambda { |message|
          text_with_mod.mods << PrependLine.from_node_and_content(node, "# YARD to RBS Error: #{message}")
        }
      end

      #: [X] (Prism::Node) { () -> X } -> X
      def capture_error_to_write_comment(node, &block)
        capture_error_message(subscriber_to_prepend_error(node), &block)
      end
    end
  end
end
