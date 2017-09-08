
class Multisync::Toplevel
  # dummy methods
  def register member; end
  def fullname; nil; end
  def rsync_options; []; end

  # from (source) is a required option and should be set at least at root level
  def source
    raise "no source (from) defined"
  end
  
  # to (destination) is a required option and should be set at least at root level
  def destination
    raise "no destination (to) defined"
  end
  
  # The top level is never the default set. To include every set as default,
  # simply define default at root level
  def default_set?
    false
  end
  
  # The toplevel never defines a check.
  def checks
    []
  end
  
  # Turn off source and destination checks on toplevel.
  # Set check_from|check_to at root level to turn on globally.
  def check_from?
    false
  end  
  def check_to?
    false
  end
end

