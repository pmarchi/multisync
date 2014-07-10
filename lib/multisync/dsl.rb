
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
end