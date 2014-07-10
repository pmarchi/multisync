
require 'shell_cmd'

class Multisync::Runtime
  attr_reader :options
  
  def initialize options
    @options = options
  end
  
  def dryrun?
    options[:dryrun]
  end
  
  def print_command?
    options[:print]
  end
  
  def rsync src, dest, rsync_options=[]
    rsync_options.unshift *%w( --stats --verbose )
    rsync_options.unshift '--dry-run' if dryrun?
    cmd = ['rsync', rsync_options, src, dest].flatten.map do |part|
      part.gsub(/\s+/, '\\ ')
    end
    ShellCmd.new(cmd).tap do |c|
      if print_command?
        puts c.cmd
      else
        c.execute do |stdout, stderr|
          print (stdout) ? stdout : stderr
        end
      end
    end
  end
end