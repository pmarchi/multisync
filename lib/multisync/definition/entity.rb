
class Multisync::Definition::Entity
  
  include Multisync::Definition::Dsl

  # The parent of the group
  attr_reader :parent
  
  # The name of the group
  attr_reader :name
  
  # All members (groups or syncs) of this group
  attr_reader :members
  
  # Collected results after run as Hash
  #  {
  #    cmd: 'rsync --stats -v source destination',
  #    action: :run,
  #    status: #<Process::Status: pid 65416 exit 0>,
  #    stdout: '',
  #    stderr: '',
  #    skip_message: 'host not reachable',
  #  }
  
  attr_reader :result

  def initialize parent, name, &block
    @members = []
    @name = name.to_s
    @parent = parent
    parent.register self
    instance_eval(&block) if block_given?
    @result = {}
  end
  
  def to_h
    {
      fullname: fullname,
      default: default?,
      source: {
        path: source,
        description: source_description,
        check: check_source?,
      },
      destination: {
        path: destination,
        description: destination_description,
        check: check_destination?,
      },
      checks: checks,
      rsync_options: rsync_options,
    }
  end
  
  # Make the definition visitable
  def accept visitor, level=0
    visitor.visit self, level
    members.map do |member|
      member.accept visitor, level+1
    end
  end
  
  def register member
    members << member
  end
  
  # The name including all parents separated by "/"
  def fullname
    [parent.fullname, name].join '/'
  end
  
  # rsync source
  def source
    @from_value || parent.source
  end
  
  def source_description
    @from_description || @from_value || parent.source_description
  end
  
  # rsync destination
  def destination
    @to_value || parent.destination
  end
  
  def destination_description
    @to_description || @to_value || parent.destination_description
  end
  
  # rsync options
  def rsync_options
    opts = @rsync_options || []
    return opts if @rsync_options_mode == :override
    parent.rsync_options + opts
  end
  
  # Is this group/sync defined as default
  def default?
    @default || parent.default?
  end
  
  # All checks from parent to child
  def checks
    (parent.checks + [@check]).compact
  end
  
  # Should source's host or path be checked before sync?
  def check_source?
    @from_check.nil? ? parent.check_source? : @from_check
  end
  
  # Should destination's host or path be checked before sync?
  def check_destination?
    @to_check.nil? ? parent.check_destination? : @to_check
  end
end