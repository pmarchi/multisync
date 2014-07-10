
require 'shell_cmd'

class Multisync::Runtime
  
  def initialize options
    @options = options
  end
  
  def rsync src, dest, options=[]
    cmd = ['rsync', '--stats', '--verbose', options, src, dest].flatten.map do |part|
      part.gsub(/\s+/, '\\ ')
    end
    ShellCmd.new cmd
  end
end