
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
end

