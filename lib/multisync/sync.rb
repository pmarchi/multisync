
class Multisync::Sync < Multisync::Entity

  # State, set after run (could be nil, :skipped, :run)
  attr_accessor :state
  
  # Result after run
  attr_accessor :result
  
  # Will set state and result on self
  def run runtime
    runtime.rsync self
  end

  def select sets
    yield self if selected?(sets)
  end
  
  def selected? sets
    sets.empty? ?
      default_set? :
      sets.any? {|s| /\b#{s}\b/.match fullname }
  end
end