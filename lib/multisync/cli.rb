require "optparse"
require "rainbow/ext/string"
require "terminal-table"

class Multisync::Cli
  def self.start
    new.start
  end

  # Given sets to run or empty
  attr_reader :sets

  def parser
    OptionParser.new do |o|
      o.banner = <<~EOS
        Run rsync jobs defined in the catalog file '#{options[:file]}'

        Usage: #{File.basename $0} [options] [SET] [...]

                SET selects a section from the catalog (see option -l)
                use / as a group/task separator.
                e.g. #{File.basename $0} nas/userdata"
      EOS

      o.separator ""
      o.on("-l", "--list", "List the catalog") do
        options[:list] = true
      end
      o.on("-p", "--print", "Print the commands without executing them") do
        options[:print] = true
      end
      o.on("-q", "--quiet", "Show only rsync summary") do
        options[:quiet] = true
      end
      o.on("--catalog FILE", "Specify a catalog", "Default is #{options[:file]}") do |file|
        options[:file] = file
      end
      o.on("--timeout SECS", Integer, "Timeout for rsync job", "Default is #{options[:timeout]}") do |timeout|
        options[:timeout] = timeout
      end
      o.on("-n", "--dryrun", "Run rsync in dry-run mode") do
        options[:dryrun] = true
      end
    end
  end

  def start
    parser.parse!
    options[:quiet] = false if options[:print]

    @sets = ARGV

    if options[:list]
      # List tasks
      puts "Catalog: #{options[:file].color(:cyan)}"
      puts
      puts Multisync::List.new catalog

    else
      # Run tasks
      return if tasks.empty?
      begin
        tasks.each do |task|
          runtime.run task
        end
      rescue Interrupt
        warn "\nAborted!".color(:red)
      end
      unless options[:print]
        puts
        puts
        puts Multisync::Summary.new tasks
      end
    end

    puts
  end

  def tasks
    @tasks ||= Multisync::Selector.new(catalog, sets).tasks
    # @tasks ||= catalog.filter sets
  end

  def catalog
    @catalog ||= Multisync::Catalog.new options[:file]
  end

  def runtime
    @runtime ||= Multisync::Runtime.new(options)
  end

  def options
    @options ||= {
      list: false,
      print: false,
      dryrun: false,
      quiet: false,
      file: Multisync::Catalog.default_catalog_path,
      timeout: 31536000 # 1 year
    }
  end
end
