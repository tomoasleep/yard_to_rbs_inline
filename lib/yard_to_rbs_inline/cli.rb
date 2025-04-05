# frozen_string_literal: true

# rbs_inline: enabled

require "optparse"

module YardToRbsInline
  class Cli
    def self.start(argv)
      opt = OptionParser.new
      dry_run = false

      opt.banner = <<~STRING
        Usage: yard-to-rbs-inline [options] <files ...>

      STRING

      opt.on("-n", "--dry-run", "Dry run") { dry_run = true }
      opt.parse!(argv)

      if argv.empty?
        warn opt.help
        return 1
      end

      argv.each do |file|
        Converter.convert(file, dry_run: dry_run)
      end

      0
    end
  end
end
