
module Multisync::Dsl

  # The DSL methods
  def group name, &block
    Multisync::Group.new self, name, &block
  end
  
  def sync name, &block
    Multisync::Sync.new self, name, &block
  end
  
  def desc description
    @description = description
  end
  
  def from source, options={}
    @source = source
    # Check source's host or path before sync
    @check_from = options[:check] unless options[:check].nil?
  end
  
  def to destination, options={}
    @destination = destination
    # Check destination's host or path before sync
    @check_to = options[:check] unless options[:check].nil?
  end
  
  def options rsync_options, mode=:append
    @rsync_options_mode = mode
    @rsync_options = Array rsync_options
  end
  
  def default
    @default_set = true
  end
  
  # Defines a check, that should pass in order to invoke the sync
  def only_if cmd, options={}
    @check_cmd = cmd
    @check_message = options.fetch(:message, cmd)
  end
  
  # Check source's host or path before sync
  # can also be set as option of "from"
  def check_from flag=true
    @check_from = flag
  end
  
  # Check destination's host or path before sync
  # can also be set as option of "to"
  def check_to flag=true
    @check_to = flag
  end
end