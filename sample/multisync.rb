# Copy this file to your home: ~/.multisync.rb
# Choose one of the section A), B) or C) as a starting point
# to adjust the configuration to your needs.


################################################################################

# A) Simple rsync task

sync :simple do
  from "~/Documents"
  to "/PathToExternalDisk"
  options %w( --archive --exclude=.DS_Store ) # as array
end

# This task can be run with: "multisync simple"


################################################################################

# B) Group of rsync tasks

group :userdata do
  
  # Define the target path for the whole group and check the existance of the
  # target path before running the rsync task.
  # Also set an optional description for the target.
  to "/PathToExternalDisk", description: "External HD", check: true

  # Define rsync options for the whole group
  options %w( --archive --exclude=.DS_Store )
  
  sync :desktop do
    # With optional description of the source
    from "~/Desktop", description: "Desktop"
  end

  sync :documents do
    from "~/Documents", description: "Documents"
  end

  sync :downloads do
    from "~/Downloads", description: "Downloads"
    # Add options specific to this task.
    options %w( --exclude='*.download' )
  end
end

# Run the whole group with: "multisync userdata"
# Run a single taks with: "multisync userdata/downloads"


################################################################################

# C) Real world example using templates, defaults and options override

# rsync options for all tasks
options %w( --archive --delete --delete-excluded --delete-after --exclude=.DS_Store --exclude=.localized )


# Use templates to define a set of tasks that can be included later
template :data do
  
  # Always check the existance of the source path
  check_from true
  
  # rsync tasks with uncomplete arguments:
  # Define the target later where the template will be included.
  # This can be used to sync multiple directories to different remote locations.
  sync :documents do
    from "~/Documents", description: "Documents"
  end

  sync :pictures do
    from "~/Pictures", description: "Pictures"
  end

  sync :downloads do
    from "~/Downloads", description: "Downloads"
    # Don't merge options
    options %w( --times --exclude='*.download' ), :override
  end
end


group :hd do
  # Uncomment the following line to run this group by default
  # default
  
  # Define the target to be used by all tasks.
  # The existance of the target path should be checked.
  to "/TargetPathToBackupDisk/MyComputer", description: "External Disk", check: true
  
  # Include the template with the task definitions
  include :data
end

group :nas do
  to "user@nas.local:/data/backup/my_computer", description: "NAS", check: true
  
  # Include the template with the task definitions
  include :data
end

# Run both groups with: "multisync hd nas"
# Sync "desktop" to "hd" and "nas": "multisync desktop"
# Sync "desktop" to "hd" only: "multisync hd/desktop"


################################################################################

# Additional notes
# - groups can be nested
# - use "default" to run one or more groups without specifing a name
# - "default" can also be set on the top level and defines all tasks as default.
