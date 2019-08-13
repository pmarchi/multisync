
require 'mixlib/shellout'

class Multisync::Runtime

  # Runtime options
  #   dryrun: true|false
  #   show: true|false
  attr_reader :options
  
  def initialize options
    @options = options
  end
  
  def dryrun?
    options[:dryrun]
  end
  
  def show_only?
    options[:print]
  end
  
  def quiet?
    options[:quiet]
  end
  
  def timeout
    options[:timeout]
  end
  
  def run sync
    rsync_options = sync.rsync_options.dup
    rsync_options.unshift '--stats'
    rsync_options.unshift '--verbose' unless quiet?
    rsync_options.unshift '--dry-run' if dryrun?

    # escape path by hand, shellescape escapes also ~, but we want to keep its
    # special meaning for home, instead of passing it as literal char
    source, destination = [sync.source, sync.destination].map {|path| path.gsub(/\s+/, '\\ ') }
    cmd = "rsync #{rsync_options.join(' ')} #{source} #{destination}"
    cmd_options = { timeout: timeout }
    cmd_options.merge!({live_stdout: $stdout, live_stderr: $stderr}) unless quiet?
    rsync = Mixlib::ShellOut.new(cmd, cmd_options)
    sync.result[:cmd] = rsync.command

    unless quiet?
      puts
      puts [sync.source_description, sync.destination_description].join(' --> ').color(:cyan)
    end
    
    # Perform all only_if checks, from top to bottom
    sync.checks.each do |check|
      next unless Mixlib::ShellOut.new(check[:cmd]).run_command.error?

      puts check[:cmd] + ' (failed)'
      puts "Skip: ".color(:yellow) + rsync.command
      sync.result[:action] = :skip
      sync.result[:skip_message] = check[:message]
      return
    end
    
    # source check
    if sync.check_source? && ! check_path(sync.source, :source)
      puts "Source #{sync.source} is not accessible"
      puts "Skip: ".color(:yellow) + rsync.command
      sync.result[:action] = :skip
      sync.result[:skip_message] = "Source is not accessible"
      return
    end
    
    # target check
    if sync.check_destination? && ! check_path(sync.destination, :destination)
      puts "Destination #{sync.destination} is not accessible"
      puts "Skip: ".color(:yellow) + rsync.command
      sync.result[:action] = :skip
      sync.result[:skip_message] = "Destination is not accessible"
      return
    end
      
    if show_only?
      puts rsync.command
    else
      sync.result[:action] = :run
      puts rsync.command if dryrun?
      rsync.run_command
      sync.result[:status] = rsync.status
      sync.result[:stdout] = rsync.stdout
      sync.result[:stderr] = rsync.stderr
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