
class Multisync::Entity
  
  include Multisync::Dsl

  # The parent of the group
  attr_reader :parent
  
  # The name of the group
  attr_reader :name
  
  # All members (groups or syncs) of this group
  attr_reader :members

  def initialize parent=Multisync::Toplevel.new, name=:root, &block
    @parent = parent
    @name = name.to_s
    @members = []
    parent.register self
    instance_eval(&block) if block_given?
  end
  
  def register member
    members << member
  end
  
  def list level=0
    if level > 0
      print ''.ljust(2*(level-1), ' ')
      n = (default_set? ? name + ' *' : name)
      print n.color(:cyan)
      print " #{''.ljust(30-2*level-n.length, ' ')} #{description}" unless description == name
      puts
    end
    members.map {|m| m.list level+1}
  end
  
  def dump
    puts fullname
    members.map(&:dump)
  end

  # The name including all parents separated by "/"
  def fullname
    [parent.fullname, name].join '/'
  end
  
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
  
  # Is this group/sync defined as default
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
  
  # Should source's host or path be checked before sync?
  def check_from?
    @check_from.nil? ? parent.check_from? : @check_from
  end
  
  # Should destination's host or path be checked before sync?
  def check_to?
    @check_to.nil? ? parent.check_to? : @check_to
  end
end