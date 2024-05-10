# rbs_inline: enabled

require 'optparse'

module YardToRbsInlineExample
  class Cli
    def self.start(argv)
      opt = OptionParser.new
      dry_run = false

      opt.on('-n', '--dry-run', 'Dry run') { dry_run = true }
      opt.parse!(argv)

      argv.each do |file|
        Converter.convert(file, dry_run: dry_run)
      end
    end
  end
end
