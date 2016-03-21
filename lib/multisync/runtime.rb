
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
  
  def rsync src, dest, rsync_options=[]
    rsync_options.unshift *%w( --stats --verbose )
    rsync_options.unshift '--dry-run' if dryrun?
    cmd = (
      ['rsync', rsync_options] +
      [src, dest].map {|path| path.gsub(/\s+/, '\\ ') }
    ).flatten

    puts cmd.join(' ') if dryrun?
    ShellCmd.new(cmd).tap do |c|
      c.execute do |stdout, stderr|
        print (stdout) ? stdout : stderr
      end
    end
  end
end