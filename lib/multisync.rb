require "multisync/version"

module Multisync
  autoload :Cli, 'multisync/cli'
  autoload :Definition, 'multisync/definition'
  autoload :Catalog, 'multisync/catalog'
  autoload :Selector, 'multisync/selector'
  autoload :Runtime, 'multisync/runtime'
  autoload :RsyncStat, 'multisync/rsync_stat'
  autoload :Summary, 'multisync/summary'
  autoload :List, 'multisync/list'
end
