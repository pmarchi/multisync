
require 'shellwords'
require 'shell_cmd'

class Multisync::Runtime
  attr_reader :options
  
  def initialize options
    @options = options
  end
  
  def dryrun?
    options[:dryrun]
  end
  
  def show_only?
    options[:show]
  end
  
  def rsync sync
    rsync_options = sync.rsync_options.dup
    rsync_options.unshift *%w( --stats --verbose )
    rsync_options.unshift '--dry-run' if dryrun?
    cmd = (
      ['rsync', rsync_options] +
      [sync.source, sync.destination].map {|path| path.gsub(/\s+/, '\\ ') }
    ).flatten

    shell_cmd = ShellCmd.new(cmd)
    
    puts
    puts sync.description.bold.cyan

    if sync.check_passed?
      if show_only?
        sync.state = :show
        puts shell_cmd.cmd
      else
        sync.state = :run
        puts shell_cmd.cmd if dryrun?
        sync.result = shell_cmd.execute do |stdout, stderr|
          print (stdout) ? stdout : stderr
        end
      end
    else
      sync.state = :skipped
      puts sync.check_cmd + ' (failed)'
      puts "Skip: ".bold.yellow + shell_cmd.cmd if show_only?
    end

  end
end