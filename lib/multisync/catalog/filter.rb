
class Multisync::Catalog::Filter
  # selected sets
  attr_reader :sets
  
  # selected subjects
  attr_reader :result

  def initialize sets
    @sets = Array(sets)
    @result = []
  end

  def visit subject, _level
    result << subject if selected?(subject)
  end
  
  def selected? subject
    # only return the leaves of the definition tree
    return false unless subject.members.empty?
    # no sets defined, but subject is in the default set
    return true if sets.empty? && subject.default?
    # subject matches any of the given sets
    sets.any? {|set| /\b#{set}\b/.match subject.fullname }
  end
end