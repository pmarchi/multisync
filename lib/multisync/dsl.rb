
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
  
  def from source
    @source = source
  end
  
  def to destination
    @destination = destination
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

  # The accessors
  # A description for the entity
  def description
    @description || name
  end
  
  # rsync source
  def source
    @source || parent.source
  end
  
  # rsync destination
  def destination
    @destination || parent.destination
  end
  
  # rsync options
  def rsync_options
    opts = @rsync_options || []
    return opts if @rsync_options_mode == :override
    parent.rsync_options + opts
  end
  
  # run this group/sync by default (when no set is defined)
  def default_set?
    @default_set || parent.default_set?
  end
  
  # Run this group/sync only if all checks passed
  def check_passed?
    parent.check_passed? && check
  end
  
  # Return the message of the check that failed
  def check_message
    parent.check_passed? ? @check_message : parent.check_message
  end
  
  # Return the cmd of the check that failed
  def check_cmd
    parent.check_passed? ? @check_cmd : parent.check_cmd
  end
  
  # Perform the actual check
  def check
    @check_passed = (@check_cmd ? system(@check_cmd) : true) if @check_passed.nil?
    @check_passed
  end
end