
require 'open3'
require 'shellwords'
require 'shell_cmd'

class Multisync::Runtime

  # Runtime options
  #   dryrun: true|false
  #   show: true|false
  attr_reader :options
  
  # Array of collected result hashs
  #  {
  #    name: 'Source',
  #    description: 'Source > Destination',
  #    cmd: 'rsync --stats -v source destination',
  #    action: :run,
  #    result: #<ShellCmd:0x007fdf88947838 ...>,
  #    skip_message: 'host not reachable',
  #  }
  attr_reader :results
  
  def initialize options
    @options = options
    @results = []
  end
  
  def dryrun?
    options[:dryrun]
  end
  
  def show_only?
    options[:show]
  end
  
  def rsync sync
    result = { name: sync.name, description: sync.description }
    rsync_options = sync.rsync_options.dup
    rsync_options.unshift *%w( --stats --verbose )
    rsync_options.unshift '--dry-run' if dryrun?
    
    source, destination = [sync.source, sync.destination].map {|path| path.gsub(/\s+/, '\\ ') }
    cmd = ['rsync', rsync_options, source, destination].flatten

    shell = ShellCmd.new(cmd)
    result[:cmd] = shell.cmd
    
    puts
    puts sync.description.color(:cyan)
    
    # Perform all only_if checks, from top to bottom
    sync.checks.each do |check|
      _, status = Open3.capture2e check[:cmd]
      next if status.success?

      puts check[:cmd] + ' (failed)'
      puts "Skip: ".color(:yellow) + shell.cmd
      result[:action] = :skip
      result[:skip_message] = check[:message]
      results << result
      return
    end
    
    # source check
    if sync.check_from? && ! check_path(source, :source)
      puts "Source #{source} is not accessible"
      puts "Skip: ".color(:yellow) + shell.cmd
      result[:action] = :skip
      result[:skip_message] = "Source is not accessible"
      results << result
      return
    end
    
    # target check
    if sync.check_to? && ! check_path(destination, :destination)
      puts "Destination #{destination} is not accessible"
      puts "Skip: ".color(:yellow) + shell.cmd
      result[:action] = :skip
      result[:skip_message] = "Destination is not accessible"
      results << result
      return
    end
      
    if show_only?
      puts shell.cmd
    else
      result[:action] = :run
      puts shell.cmd if dryrun?
      result[:result] = shell.execute do |stdout, stderr|
        print (stdout) ? stdout : stderr
      end
    end
    
    results << result
  end
  
  # checks a path
  # if path includes a host, the reachability of the host will be checked
  # the existence of the remote path will not be checked
  # if path is a local source path, its existence will be checked
  # if path is a local destination path, the existence of the parent will be checked
  def check_path path, type = :source
    if path.include? ':'
      host = path.split(':').first.split('@').last
      _, status = Open3.capture2e "ping -o -t 1 #{host}"
      status.success?
    else
      path = File.dirname path if type == :destination
      File.exist? path
    end
  end
end