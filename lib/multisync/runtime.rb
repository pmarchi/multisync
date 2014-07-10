
require 'shell_cmd'

class Multisync::Runtime
  attr_reader :options
  
  def initialize options
    @options = options
  end
  
  def rsync src, dest, rsync_options=[]
    cmd = ['rsync', '--stats', '--verbose', rsync_options, src, dest].flatten.map do |part|
      part.gsub(/\s+/, '\\ ')
    end
    ShellCmd.new(cmd).tap do |c|
      if options[:dryrun]
        puts c.cmd
      else
        c.execute do |stdout, stderr|
          print (stdout) ? stdout : stderr
        end
      end
    end
  end
end