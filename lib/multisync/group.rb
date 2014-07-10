
class Multisync::Group < Multisync::Entity
  def run runtime, sets
    members.map do |member|
      member.run runtime, sets
    end.flatten.compact
  end
end