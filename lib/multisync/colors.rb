require "rainbow"

module Multisync::Colors
  def as_note x
    Rainbow(x).faint
  end

  def as_main x
    Rainbow(x).color(:cyan).bold
  end

  def as_skipped x
    Rainbow(x).color(:yellow)
  end

  def as_success x
    Rainbow(x).color(:green)
  end

  def as_fail x
    Rainbow(x).color(:red)
  end
end
