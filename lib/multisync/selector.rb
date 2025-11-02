class Multisync::Selector
  # Given catalog
  attr_reader :catalog

  # Given queries
  attr_reader :queries

  # Selected tasks
  attr_reader :results

  def initialize catalog, queries
    @catalog = catalog
    @queries = queries
    @results = []
    @all_subjects = []
    @subjects_by_name = []
  end

  def tasks parents: false
    catalog.traverse self
    parents ? selected_with_parents : selected
  end

  def visit subject
    results << subject
  end

  def selected_with_parents
    @selected_with_parents ||= results.select { selected_or_parent_of_selected? _1 }
  end

  def selected_or_parent_of_selected? subject
    !subject.fullname.empty? &&
      selected_fullnames.any? { %r{^#{subject.fullname}(?:/|$)}.match _1 }
  end

  def selected_fullnames
    @selected_fullnames ||= selected.map(&:fullname)
  end

  def selected
    @selected ||= results.select { selected? _1 }
  end

  def selected? subject
    # return only subjects with a fullname
    return false if subject.fullname.empty?

    # no queries defined, but subject is in the default set
    return true if queries.empty? && subject.default?

    # only return the leaves of the definition tree
    # return false unless subject.members.any?

    # subject matches any of the given queries
    queries.any? { /\b#{_1}\b/.match subject.fullname }
  end
end
