
class Multisync::Catalog
  autoload :List, 'multisync/catalog/list'
  autoload :Filter, 'multisync/catalog/filter'
  
  # top entity of catalog
  attr_reader :top

  def self.load file
    new.load file
  end
  
  def load file
    @top = Multisync::Entity.new(Multisync::EntityNull.new, '__MAIN__')
    top.instance_eval(File.read(file))
    self
  end
  
  def list
    catalog_list = Multisync::Catalog::List.new
    top.accept(catalog_list)
    catalog_list.result
  end
  
  def filter sets
    catalog_filter = Multisync::Catalog::Filter.new sets
    top.accept(catalog_filter)
    catalog_filter.result
  end
end
