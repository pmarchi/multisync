require "multisync/version"

module Multisync
  autoload :Cli, 'multisync/cli'
  autoload :Definition, 'multisync/definition'
  autoload :Catalog, 'multisync/catalog'
  autoload :Runtime, 'multisync/runtime'
  autoload :RsyncStat, 'multisync/rsync_stat'
end
