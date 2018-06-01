require "multisync/version"

module Multisync
  autoload :Catalog, 'multisync/catalog'
  autoload :Dsl, 'multisync/dsl'
  autoload :Entity, 'multisync/entity'
  autoload :EntityNull, 'multisync/entity_null'
  autoload :Runtime, 'multisync/runtime'
  autoload :RsyncStat, 'multisync/rsync_stat'
end
