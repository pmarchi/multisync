
class Multisync::Entity
  
  include Multisync::Dsl

  class Toplevel
    def register member; end
    def fullname; nil; end
    def rsync_options; []; end
    def source; raise "no source (from) defined"; end
    def destination; raise "no destination (to) defined"; end
  end

  # The parent of the group
  attr_reader :parent
  
  # The name of the group
  attr_reader :name
  
  # All members (groups or syncs) of this group
  attr_reader :members
  
  def initialize parent=Toplevel.new, name='root', &block
    @parent = parent
    @name = name.to_s
    @members = []
    parent.register self
    instance_eval(&block) if block_given?
  end
  
  def register member
    members << member
  end
  
  def fullname
    [parent.fullname, name].join '/'
  end
  
  def list level=0
    print ''.ljust(2*level, ' ')
    print name.bold
    print " (#{description})" if description
    puts
    members.map {|m| m.list level+1}
  end
  
  def dump
    puts fullname
    members.map(&:dump)
  end
end