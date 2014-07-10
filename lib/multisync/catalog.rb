
class Multisync::Catalog < Multisync::Group
  class << self
    def load file
      new.load file
    end
  end
  
  def load file
    instance_eval(File.read(file))
    self
  end
end
