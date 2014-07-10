
class Multisync::Sync < Multisync::Entity
  # The result from the last run
  attr_reader :result
  
  def run runtime, sets
    return unless run? sets
    puts
    puts description.bold.yellow
    @result = runtime.rsync source, destination, rsync_options
    self
  end
  
  def run? sets
    sets.any? {|s| /\b#{s}\b/.match fullname }
  end
end