# frozen_string_literal: true

require_relative "multisync/version"

module Multisync
  class Error < StandardError; end

  autoload :Cli, "multisync/cli"
  autoload :Colors, "multisync/colors"
  autoload :Definition, "multisync/definition"
  autoload :Catalog, "multisync/catalog"
  autoload :Selector, "multisync/selector"
  autoload :Runtime, "multisync/runtime"
  autoload :RsyncStat, "multisync/rsync_stat"
  autoload :Summary, "multisync/summary"
  autoload :List, "multisync/list"
end
