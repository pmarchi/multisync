
require 'filesize'

class Multisync::RsyncStat
  
  def initialize output
    @output = output
  end

  # Build an internal hash with normalized stats  
  def parse
    @stats = definitions.each_with_object({}) do |definition, stats|
      value = scan[definition[:match]]
      stats[definition[:key]] = value ? (definition[:coerce] ? definition[:coerce].call(value) : value) : definition[:default]
    end
    self
  end
  
  # Scan output and return a hash
  #   {
  #     "Number of files" => "35,648",
  #     "Number of created files" => "0",
  #     "Number of deleted files" => "0",
  #     "Number of regular files transferred"=>"0",
  #     ...
  #   }
  def scan
    @scan ||= @output.scan(/(#{definitions.map{|d| d[:match] }.join('|')}):\s+([,0-9]+)/).each_with_object({}) {|(k,v), o| o[k] = v }
  end
  
  def to_a
    [
      @stats[:files],
      @stats[:created],
      @stats[:deleted],
      @stats[:transferred],
      @stats[:file_size],
      @stats[:transferred_size],
    ]
  end
  
  def method_missing name
    key = name.to_sym
    return @stats[key] if @stats.keys.include? key
    super
  end
  
  def definitions
    [
      { key: :files, match: 'Number of files', coerce: ->(x) { x.gsub(',',"'") }, default: '0' },
      { key: :created, match: 'Number of created files', coerce: ->(x) { x.gsub(',',"'") }, default: '0' },
      { key: :deleted, match: 'Number of deleted files', coerce: ->(x) { x.gsub(',',"'") }, default: '0' },
      { key: :transferred, match: 'Number of regular files transferred', coerce: ->(x) { x.gsub(',',"'") }, default: '0' },
      { key: :file_size, match: 'Total file size', coerce: ->(x) { Filesize.new(x.gsub(',','').to_i).pretty }, default: '0 B' },
      { key: :transferred_size, match: 'Total transferred file size', coerce: ->(x) { Filesize.new(x.gsub(',','').to_i).pretty }, default: '0 B' },
    ]
  end
end