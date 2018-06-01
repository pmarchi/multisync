
class Multisync::Definition::Template
  include Multisync::Definition::Dsl
  
  @registered = []
  
  def self.register instance
    @registered << instance
  end
  
  def self.lookup name
    @registered.find {|instance| instance.name == name }
  end
  
  # The name of the template
  attr_reader :name
  
  # The block the template holds
  attr_reader :block
  
  def initialize name, &block
    @name = name
    self.class.register self
    @block = block
  end
end