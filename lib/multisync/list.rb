require "rainbow/ext/string"

class Multisync::List
  # Given catalog
  attr_reader :catalog

  # Tasks
  attr_reader :tasks

  def initialize catalog
    @catalog = catalog
    @tasks = []
  end

  def to_s
    catalog.traverse self
    table.to_s
  end

  def table
    Terminal::Table.new(rows: tasks, style: table_style)
  end

  def visit subject, level
    if level > 0
      tab = "".ljust(2 * (level - 1), " ")
      default = subject.default? ? " *" : ""
      name = "#{tab}#{subject.name}#{default}"
      tasks << [name, *description(subject).map(&:faint)]
      # puts "#{name.ljust(32, " ")}#{description(subject)}"
    end
  end

  def description subject
    desc = [subject.source_description, subject.destination_description]
    desc.any?(&:empty?) ? [] : [desc.first, ["--> ", desc.last].join]
  end

  def table_style
    {border_top: false, border_bottom: false, border_x: "–", border_y: "", border_i: "", padding_left: 0, padding_right: 3}
  end
end
