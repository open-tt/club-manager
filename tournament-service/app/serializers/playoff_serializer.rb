class PlayoffSerializer < ActiveModel::Serializer
  attributes :id, :rounds
  # has_many :matches # todo: investigate why this is not working. it works for tournament and groups

  def matches
    @object.matches.map do |match|
      MatchSerializer.new(match)
    end
  end

  def rounds
    @object.rounds.map do |round|
      RoundSerializer.new(round)
    end
  end
end
