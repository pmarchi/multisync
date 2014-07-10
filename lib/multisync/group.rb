
class Multisync::Group < Multisync::Entity
  def run runtime, sets
    members.each do |member|
      member.run runtime, sets
    end
  end
end