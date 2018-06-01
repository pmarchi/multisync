
class Multisync::Definition::Null < Multisync::Definition::Entity
  
  def initialize
  end
  
  def register member
  end

  def fullname
    nil
  end

  def rsync_options
    []
  end

  # from (source) is a required option and should be set at least at root level
  def source
    raise "no source (from) defined"
  end
  
  def source_description
    ''
  end
  
  # to (destination) is a required option and should be set at least at root level
  def destination
    raise "no destination (to) defined"
  end
  
  def destination_description
    ''
  end
  
  def default?
    false
  end
  
  def checks
    []
  end

  def check_source?
    false
  end  

  def check_destination?
    false
  end
end

