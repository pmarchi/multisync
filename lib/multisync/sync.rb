
class Multisync::Sync < Multisync::Entity

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