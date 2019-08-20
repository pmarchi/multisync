
class Multisync::Summary
  
  # All tasks to include in the summary
  attr_reader :tasks
  
  def initialize tasks
    @tasks = tasks
  end
  
  def to_s
    table.to_s
  end
  
  def table
    Terminal::Table.new(headings: headings, rows: data, style: table_style)
  end
  
  def headings
    %w( Source Destination Files + - → ∑ ↑ ).zip(%i( left left right right right right right right )).map{|v,a| {value: v, alignment: a} }
  end
  
  def data
    # Exclude tasks with an empty result (> not run) first
    tasks.map do |task|
      result = task.result
      desc = [task.source_description, "--> #{task.destination_description}"]

      case result[:action]
      when :run
        if result[:status] && result[:status].success?
          # successfull run
          stat = Multisync::RsyncStat.new(result[:stdout]).parse
          [*desc, *stat.to_a.map{|e| {value: e.color(:green), alignment: :right} } ]
        else
          # failed or interrupted run
          [*desc, { value: (result[:stderr] || 'n/a').strip.color(:red), colspan: 6 } ]
        end

      when :skip
        # skiped sync
        [*desc, { value: result[:skip_message].color(:yellow), colspan: 6 } ]

      else
        # not executed
        [*desc, { value: 'not executed'.faint, colspan: 6 } ]
      end
    end
  end
  
  def table_style
    { border_top: false,  border_bottom: false, border_x: '–', border_y: '', border_i: '', padding_left: 0, padding_right: 3 }
  end

end
