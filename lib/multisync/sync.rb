
class Multisync::Sync < Multisync::Entity

  # State, set after run (could be nil, :skipped, :run)
  attr_reader :state
  
  # Result after run
  attr_reader :result
  
  def run runtime
    puts
    puts description.bold.cyan

    if check_passed?
      @result = runtime.rsync source, destination, rsync_options
      @state = :run
    else
      puts check_cmd + ' (failed)'
      @state = :skipped
    end
  end
  
  def cmd
    ['rsync', rsync_options, source, destination].join(' ')
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