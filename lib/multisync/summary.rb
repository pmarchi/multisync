class Multisync::Summary
  include Multisync::Colors

  # All tasks to include in the summary
  attr_reader :tasks

  def initialize tasks
    @tasks = tasks
  end

  def to_s
    ["", as_main("Summary"), table.to_s, failures].compact.join("\n")
  end

  def table
    Terminal::Table.new(headings: headings, rows: data, style: table_style)
  end

  def headings
    %w[SOURCE DESTINATION FILES + - → ∑ ↑]
      .map(&method(:as_note))
      .zip(%i[left left right right right right right right])
      .map { |v, a| {value: v, alignment: a} }
  end

  def data
    tasks.map do |task|
      result = task.result
      desc = [task.source_description, task.destination_description]

      case result[:action]
      when :run
        if result[:status]&.success?
          # successfull run
          stats = Multisync::RsyncStat.new(result[:stdout])
          [*desc, *stats.formatted_values.map { {value: as_success(_1), alignment: :right} }]
        else
          # failed or interrupted run
          [*desc, as_message(as_fail("Failed, for more information see details below"))]
          # [*desc, as_message(as_fail(result[:stderr] || "n/a").strip)]
        end

      when :skip
        # skiped sync
        [*desc, as_message(as_skipped(result[:skip_message]))]

      else
        # not executed
        [*desc, as_message(as_note("not executed"))]
      end
    end.push(
      [
        as_note("Total"),
        "",
        *Multisync::RsyncStat
          .formatted_totals
          .map { {value: as_note(_1), alignment: :right} }
      ]
    )
  end

  def failures
    tasks
      .select { _1.result[:action] == :run && !_1.result[:status]&.success? }
      .flat_map do |task|
        [
          as_fail([task.source_description, task.destination_description].join(" --> ")),
          message_or_nil(task.result[:stdout]),
          message_or_nil(task.result[:stderr]),
          ""
        ].compact
      end
      # Add title if any failures
      .tap { _1.unshift "\n#{as_main("Failures")}" if _1.any? }
      # Return failures as string or nil
      .then { _1.any? ? _1.join("\n") : nil }
  end

  def as_message message
    {value: message, colspan: 6}
  end

  def message_or_nil message
    (message.nil? || message.empty?) ? nil : message
  end

  def table_style
    {border_x: as_note("─"), border_y: "", border_i: "", border_top: false, border_bottom: false, padding_left: 0, padding_right: 3}
  end
end
