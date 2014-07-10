
class Multisync::Sync < Multisync::Entity
  def run runtime, sets
    if run? sets
      runtime.rsync source, destination, rsync_options
    end
  end
  
  def run? sets
    sets.any? {|s| /\b#{s}\b/.match fullname }
  end
end