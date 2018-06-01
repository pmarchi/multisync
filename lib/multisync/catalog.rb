
class Multisync::Catalog
  autoload :List, 'multisync/catalog/list'
  autoload :Filter, 'multisync/catalog/filter'
  
  # top entity of definition
  attr_reader :definition

  def initialize path
    @path = File.expand_path(path)
  end
  
  def definition
    @_definition ||= Multisync::Definition::Entity.new(Multisync::Definition::Null.new, '__MAIN__').tap do |e|
      e.instance_eval File.read(path)
    end
  end
  
  def list
    catalog_list = Multisync::Catalog::List.new
    definition.accept(catalog_list)
    catalog_list.result
  end
  
  def filter sets
    catalog_filter = Multisync::Catalog::Filter.new sets
    definition.accept(catalog_filter)
    catalog_filter.result
  end

  def path
    return @path if File.exist? @path
    sample_path = File.expand_path('../../../sample/multisync.rb', __FILE__)
    raise RuntimeError.new, "No catalog found at #{@path}. Copy sample from #{sample_path} to #{@path} and adjust to your needs."
  end
  
  def self.default_catalog_path
    '~/.multisync.rb'
  end
end
