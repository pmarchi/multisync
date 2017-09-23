
require 'mixlib/shellout'

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
  #    result: #<Process::Status: pid 65416 exit 0>,
  #    stdout: '',
  #    stderr: '',
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
    results << result

    rsync_options = sync.rsync_options.dup
    rsync_options.unshift *%w( --stats --verbose )
    rsync_options.unshift '--dry-run' if dryrun?

    # escape path by hand, shellescape escapes also ~, but we want to keep its
    # special meaning for home, instead of passing it as literal char
    source, destination = [sync.source, sync.destination].map {|path| path.gsub(/\s+/, '\\ ') }
    cmd = "rsync #{rsync_options.join(' ')} #{source} #{destination}"
    rsync = Mixlib::ShellOut.new(cmd, live_stdout: $stdout, live_stderr: $stderr)
    result[:cmd] = rsync.command
    
    puts
    puts sync.description.color(:cyan)
    
    # Perform all only_if checks, from top to bottom
    sync.checks.each do |check|
      next unless Mixlib::ShellOut.new(check[:cmd]).run_command.error?

      puts check[:cmd] + ' (failed)'
      puts "Skip: ".color(:yellow) + rsync.command
      result[:action] = :skip
      result[:skip_message] = check[:message]
      return
    end
    
    # source check
    if sync.check_from? && ! check_path(sync.source, :source)
      puts "Source #{sync.source} is not accessible"
      puts "Skip: ".color(:yellow) + rsync.command
      result[:action] = :skip
      result[:skip_message] = "Source is not accessible"
      return
    end
    
    # target check
    if sync.check_to? && ! check_path(sync.destination, :destination)
      puts "Destination #{sync.destination} is not accessible"
      puts "Skip: ".color(:yellow) + rsync.command
      result[:action] = :skip
      result[:skip_message] = "Destination is not accessible"
      return
    end
      
    if show_only?
      puts rsync.command
    else
      result[:action] = :run
      puts rsync.command if dryrun?
      rsync.run_command
      result[:status] = rsync.status
      result[:stdout] = rsync.stdout
      result[:stderr] = rsync.stderr
    end
  end
  
  # checks a path
  # if path includes a host, the reachability of the host will be checked
  # the existence of the remote path will not be checked
  # if path is a local source path, its existence will be checked
  # if path is a local destination path, the existence of the parent will be checked
  def check_path path, type = :source
    if path.include? ':'
      host = path.split(':').first.split('@').last
      Mixlib::ShellOut.new("ping -o -t 1 #{host}").run_command.status.success?
    else
      abs_path = File.expand_path path
      abs_path = File.dirname abs_path if type == :destination
      File.exist? abs_path
    end
  end
end