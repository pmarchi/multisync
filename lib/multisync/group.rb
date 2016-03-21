
class Multisync::Group < Multisync::Entity
  def select sets
    members.each do |member|
      member.select sets do |sync|
        yield sync if sync
      end
    end
  end
end