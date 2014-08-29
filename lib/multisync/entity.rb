
class Multisync::Entity
  
  include Multisync::Dsl

  # The parent of the group
  attr_reader :parent
  
  # The name of the group
  attr_reader :name
  
  # All members (groups or syncs) of this group
  attr_reader :members
  
  def initialize parent=Multisync::Toplevel.new, name='root', &block
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
    if level > 0
      print ''.ljust(2*(level-1), ' ')
      n = (default_set? ? name + '*' : name)
      print n.bold
      print " #{''.ljust(30-2*level-n.length, ' ')} #{description}" unless description == name
      puts
    end
    members.map {|m| m.list level+1}
  end
  
  def dump
    puts fullname
    members.map(&:dump)
  end
end