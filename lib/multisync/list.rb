class Multisync::List
  include Multisync::Colors

  # Given catalog
  attr_reader :catalog

  # Tasks
  attr_reader :tasks

  def initialize tasks
    @tasks = tasks
  end

  def to_s
    "\n" + table.to_s
  end

  def table
    Terminal::Table.new(rows: rows, style: table_style)
  end

  def rows
    tasks.map do |task|
      next unless task.level > 0

      indent = "".ljust(2 * (task.level - 1), " ")
      default = task.default? ? as_note(" *") : ""
      [
        [indent, task.name, default].join,
        *descriptions(task)
      ]
    end
  end

  def descriptions task
    if [task.source_description, task.destination_description].any?(&:empty?)
      ["", "", ""]
    else
      [task.source_description, "-->", task.destination_description].map(&method(:as_note))
    end
  end

  def table_style
    {border_x: as_note("─"), border_y: "", border_i: "", border_top: false, border_bottom: false, padding_left: 0, padding_right: 3}
  end
end
