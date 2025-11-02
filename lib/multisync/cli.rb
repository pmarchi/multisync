require "thor"
require "rainbow"
require "terminal-table"

class Multisync::Cli < Thor
  include Thor::Actions
  include Multisync::Colors

  def self.exit_on_failure? = true

  class_option :catalog, aliases: "-f", default: Multisync::Catalog.default_catalog_path, desc: "Specify a custom catalog file"

  desc "list [QUERY ...]", "List catalog tasks"
  long_desc <<~LONGDESC
    List catalog tasks

    QUERY selects a section from the catalog (see list)
    \x05use / as a group/task separator.
    \x05e.g. #{File.basename $0} nas/userdata"
  LONGDESC
  method_option :all, aliases: "-a", type: :boolean, desc: "List all tasks"
  def list *queries
    queries = ["."] if options[:all]
    tasks = Multisync::Selector.new(catalog, queries).tasks(parents: true)

    puts "Catalog file: #{as_main(options[:catalog])}"
    puts Multisync::List.new(tasks)
  end

  desc "start [QUERY ...]", "Run catalog tasks"
  long_desc <<~LONGDESC
    Run catalog tasks

    QUERY selects a section from the catalog (see list)
    \x05use / as a group/task separator.
    \x05e.g. #{File.basename $0} nas/userdata"
  LONGDESC
  method_option :timeout, aliases: "-t", type: :numeric, default: 31536000, desc: "Timeout for single rsync task" # 1 year
  method_option :print, aliases: "-p", type: :boolean, desc: "Print commands without executing"
  method_option :quiet, aliases: "-q", type: :boolean, desc: "Run tasks quietly"
  method_option :summary, type: :boolean, default: true, desc: "Show summary"
  method_option :dryrun, aliases: "-n", type: :boolean, desc: "Run jobs in dry-run, don't make any changes"
  def start *queries
    tasks = Multisync::Selector.new(catalog, queries)
      .tasks
      # only leafs of the task tree can be executed
      .select { _1.members.none? }

    # Run
    tasks.each { runtime.run _1 }
  rescue Interrupt
    warn as_fail("\nAborted!")
  ensure
    # Summarize
    puts Multisync::Summary.new(tasks) if options[:summary] && !options[:print]
  end

  desc "version", "Print version information"
  def version
    puts "multisync v#{Multisync::VERSION}"
  end

  private

  def catalog
    @catalog ||= Multisync::Catalog.new options[:catalog]
  end

  def runtime
    @runtime ||= Multisync::Runtime.new(options)
  end
end
