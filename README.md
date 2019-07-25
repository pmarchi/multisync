[![Gem Version](https://badge.fury.io/rb/multisync.svg)](https://badge.fury.io/rb/multisync)

# multisync

Multisync offers a DSL to organize sets of rsync tasks. It takes advantage of templates, groups and inheritance to simplify things.


## Installation

Install multisync with:

    $ gem install multisync


## Usage

In order to run multisync you first need a catalog file (default: `~/.multisync.rb`). Copy the [sample file](sample/multisync.rb) to `~/.multisync.rb` and use it as a starting point to adjust it to your needs.

List your configuration (and check your catalog file for errors):

    $ multisync -l


Print out the rsync commands without executing them:

    $ multisync -p


Run a group or task defined in your catalog file:

    $ multisync nas


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/multisync.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
