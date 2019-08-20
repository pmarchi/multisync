require 'optparse'
require 'rainbow/ext/string'
require 'terminal-table'

class Multisync::Cli
  
  def self.start
    new.start
  end
  
  # Given sets to run or empty
  attr_reader :sets
  
  def parser
    OptionParser.new do |o|
      o.banner = "\nRun rsync jobs defined in the catalog file '#{options[:file]}'.\n\n" +
                 "Usage: #{File.basename $0} [options] [SET] [...]\n\n" +
                 "       SET selects a section from the catalog (see option -l)\n" +
                 "       use / as a group/task separator.\n" +
                 "       e.g. #{File.basename $0} nas/userdata"
      o.separator ''
      o.on('-l', '--list', "List the catalog") do
        options[:list] = true
      end
      o.on('-p', '--print', "Print the commands without executing them") do
        options[:print] = true
      end
      o.on('-q', '--quiet', "Show only rsync summary") do
        options[:quiet] = true
      end
      o.on('--catalog FILE', "Specify a catalog", "Default is #{options[:file]}") do |file|
        options[:file] = file
      end
      o.on('--timeout SECS', Integer, "Timeout for rsync job", "Default is #{options[:timeout]}") do |timeout|
        options[:timeout] = timeout
      end
      o.on('-n', '--dryrun', "Run rsync in dry-run mode") do
        options[:dryrun] = true
      end
      o.separator ''
    end
  end
  
  def start
    parser.parse!
    @sets = ARGV
    options[:quiet] = false if options[:print]
    
    case
    when options[:list]
      list_definitions
    else
      run_tasks
    end
    puts
  end
  
  def list_definitions
    puts "Catalog: #{options[:file].color(:cyan)}"
    table = Terminal::Table.new(rows: catalog.list, style: table_style)
    puts
    puts table
  end
  
  def run_tasks
    begin
      tasks.each do |task|
        runtime.run task
      end
      return if options[:print]
    rescue Interrupt => e
      $stderr.puts "\nAborted!".color(:red)
    end
    table = Terminal::Table.new(headings: summary_headings, rows: summary_data, style: table_style)
    puts
    puts
    puts table
  end
  
  def summary_headings
    %w( Source Destination Files + - → ∑ ↑ ).zip(%i( left left right right right right right right )).map{|v,a| {value: v, alignment: a} }
  end
  
  def summary_data
    # Exclude tasks with an empty result (> not run) first
    tasks.map do |task|
      result = task.result
      desc = [task.source_description, "--> #{task.destination_description}"]

      case result[:action]
      when :run
        if result[:status] && result[:status].success?
          # successfull run
          stat = Multisync::RsyncStat.new(result[:stdout]).parse
          [*desc, *stat.to_a.map{|e| {value: e.color(:green), alignment: :right} } ]
        else
          # failed or interrupted run
          [*desc, { value: (result[:stderr] || 'n/a').strip.color(:red), colspan: 6 } ]
        end

      when :skip
        # skiped sync
        [*desc, { value: result[:skip_message].color(:yellow), colspan: 6 } ]

      else
        # not executed
        [*desc, { value: 'not executed'.faint, colspan: 6 } ]
      end
    end
  end
  
  def tasks
    @_tasks ||= catalog.filter sets
  end
  
  def catalog
    @_catalog ||= Multisync::Catalog.new options[:file]
  end
  
  def runtime
    @_runtime ||= Multisync::Runtime.new(options)
  end
  
  def options
    @_options ||= { 
      list: false,
      print: false,
      dryrun: false,
      quiet: false,
      file: Multisync::Catalog.default_catalog_path,
      timeout: 31536000, # 1 year
    }
  end
  
  def table_style
    { border_top: false,  border_bottom: false, border_x: '–', border_y: '', border_i: '', padding_left: 0, padding_right: 3 }
  end
end