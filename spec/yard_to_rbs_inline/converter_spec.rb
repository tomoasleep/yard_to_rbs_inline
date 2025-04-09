# frozen_string_literal: true

require "spec_helper"
require "tempfile"

RSpec.describe YardToRbsInline::Converter do
  describe ".convert" do
    after { tempfile.close! }

    subject do
      described_class.convert(tempfile.path)
      File.read(tempfile.path)
    end

    let(:tempfile) do
      Tempfile.new.tap do |f|
        File.write(f.path, source)
      end
    end

    let(:source) do
      <<~RUBY
        # frozen_string_literal: true

        class Code
          # @return [String]
          attr_reader :source

          # @param source [String]
          def initialize(source)
            @source = source
          end

          # @param new_source [String]
          # @return [Code]
          def rewrite(new_source)
            @source = new_source

            self
          end

          # @param recover [Boolean].
          # @return [Array<Token>]
          def tokenize(recover: false)
            parser.tokenize(source, recover: recover)
          end
        end
      RUBY
    end

    it "converts the given source" do
      expect(subject).to eq <<~RUBY
        # rbs_inline: enabled

        # frozen_string_literal: true

        class Code
          # @return [String]
          attr_reader :source #: String

          # @param source [String]
          #: (String source) -> untyped
          def initialize(source)
            @source = source
          end

          # @param new_source [String]
          # @return [Code]
          #: (String new_source) -> Code
          def rewrite(new_source)
            @source = new_source

            self
          end

          # @param recover [Boolean].
          # @return [Array<Token>]
          #: (?recover: bool) -> Array[Token]
          def tokenize(recover: false)
            parser.tokenize(source, recover: recover)
          end
        end
      RUBY
    end
  end
end
