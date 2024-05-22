# yard → rbs-inline

Insert [rbs-inline](https://github.com/soutaro/rbs-inline) comments from [YARD type annotations](https://yardoc.org/types.html) in your codes.

## Usage

Install this gem with the following command.

```console
gem install yard_to_rbs_inline
```

Then, run the following command to insert rbs-inline comments to your codes.

```console
# Print rewrited code to stdout.
yard_to_rbs_inline --dry-run your-file.rb

# Overwrite files.
yard_to_rbs_inline your-file.rb
```

## Examples

See: [examples](./examples)
