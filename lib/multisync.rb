require "multisync/version"

module Multisync
  autoload :Catalog, 'multisync/catalog'
  autoload :Dsl, 'multisync/dsl'
  autoload :Entity, 'multisync/entity'
  autoload :Group, 'multisync/group'
  autoload :Sync, 'multisync/sync'
  autoload :Toplevel, 'multisync/toplevel'
  autoload :Runtime, 'multisync/runtime'
  autoload :RsyncStat, 'multisync/rsync_stat'
end
