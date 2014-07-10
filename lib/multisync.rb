require "multisync/version"

module Multisync
  autoload :Catalog, 'multisync/catalog'
  autoload :Dsl, 'multisync/dsl'
  autoload :Entity, 'multisync/entity'
  autoload :Group, 'multisync/group'
  autoload :Sync, 'multisync/sync'
  autoload :Runtime, 'multisync/runtime'
end