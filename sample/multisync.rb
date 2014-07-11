options %w( --archive --delete --delete-excluded --exclude=.DS_Store )

group :home do
  group :cloud do
    to "/Backup/Cloud"

    sync :dropbox do
      desc "Dropbox"
      from "~/Dropbox"
      options %q(--exclude='.dropbox.cache')
    end

    sync :copy do
      desc "Copy"
      from "~/Copy"
      options %w(--archive --delete --exclude='.copy.cache'), :override
    end
  end

  sync :pictures do
    desc "Pictures"
    from "~/Pictures"
    to "/Backup"
  end
end

group :work do
  sync :doc do
    desc "Documentation"
    from "~/work/doc"
    to "/Backup"
  end
end