require "filesize"

class Multisync::RsyncStat
  # Keep track of totals
  def self.total
    @total ||= Hash.new 0
  end

  # Sample output
  #   ...
  #   Number of files: 89,633 (reg: 59,322, dir: 30,311)
  #   Number of created files: 356 (reg: 281, dir: 75)
  #   Number of deleted files: 114 (reg: 101, dir: 13)
  #   Number of regular files transferred: 344
  #   Total file size: 546,410,522,192 bytes
  #   Total transferred file size: 7,991,491,676 bytes
  #   Literal data: 7,952,503,842 bytes
  #   Matched data: 38,987,834 bytes
  #   File list size: 3,063,808
  #   File list generation time: 2.414 seconds
  #   File list transfer time: 0.000 seconds
  #   Total bytes sent: 7,957,645,803
  #   Total bytes received: 101,299
  #
  #   sent 7,957,645,803 bytes  received 101,299 bytes  23,719,067.37 bytes/sec
  #   total size is 546,410,522,192  speedup is 68.66
  def initialize output
    @output = output
  end

  # extracted returns a hash with labels as keys and extracted strings as values
  #   {
  #     "Number of files" => "35,648",
  #     "Number of created files" => "2,120",
  #     ...
  #   }
  def extracted
    @extraced ||= @output.scan(/(#{labels.join("|")}):\s+([,0-9]+)/).to_h
  end

  # stats returns a hash with the follwing keys (and updates class total)
  #   {
  #     "Number of files" => 35648,
  #     "Number of created files" => 2120,
  #     "Number of deleted files" => 37,
  #     "Number of regular files transferred" => 394,
  #     "Total file size" => 204936349,
  #     "Total transferred file size" => 49239,
  #   }
  def stats
    @stats ||= labels.each_with_object({}) do |label, h|
      value = extracted[label]&.delete(",").to_i

      self.class.total[label] += value # update total
      h[label] = value
    end
  end

  def labels
    self.class.format_map.keys
  end

  def formatted_values
    self.class.format_values do |label|
      stats[label]
    end
  end

  def self.formatted_totals
    format_values do |label|
      total[label]
    end
  end

  def self.format_values
    format_map.map do |label, format|
      format.call(yield label)
    end
  end

  def self.format_map
    {
      "Number of files" => to_numbers,
      "Number of created files" => to_numbers,
      "Number of deleted files" => to_numbers,
      "Number of regular files transferred" => to_numbers,
      "Total file size" => to_filesize,
      "Total transferred file size" => to_filesize
    }
  end

  def self.to_numbers
    ->(x) { x.to_s.gsub(/\B(?=(...)*\b)/, "'") }
  end

  def self.to_filesize
    ->(x) { Filesize.new(x).pretty }
  end
end
