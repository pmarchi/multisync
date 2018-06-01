
class Multisync::Catalog::List
  # result
  attr_reader :result

  def initialize
    @result = []
  end

  def visit subject, level
    if level > 0
      tab = ''.ljust(2*(level-1), ' ')
      default = subject.default? ? ' *' : ''
      name = "#{tab}#{subject.name}#{default}"
      @result << [name, *description(subject)]
      # puts "#{name.ljust(32, ' ')}#{description(subject)}"
    end
  end
  
  def description subject
    desc = [subject.source_description, subject.destination_description]
    desc.any?(&:empty?) ? [] : [desc.first, ['--> ', desc.last].join]
  end
end