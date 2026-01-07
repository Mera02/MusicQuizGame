require_relative 'lifelines'

class Player
  attr_reader :name
  attr_accessor :score, :streak, :lifelines
  attr_accessor :correct_answers, :games_played, :longest_streak

  def initialize(name)
    @name = name
    reset
    @longest_streak = 0
    @games_played = 0
  end

  def update_streak
    @streak += 1
    @longest_streak = [@longest_streak, @streak].max
  end

  def reset_streak
    @streak = 0
  end

  def reset
    @score = 0
    @streak = 0
    @correct_answers = 0
    @lifelines = Lifelines.new
  end

  def to_h
    {
      "name" => @name,
      "score" => @score,
      "streak" => @streak,
      "longest_streak" => @longest_streak,
      "correct_answers" => @correct_answers,
      "games_played" => @games_played,
      "lifelines" => @lifelines.to_h
    }
  end

  def self.from_h(data)
    player = Player.new(data["name"])
    player.score = data["score"]
    player.streak = data["streak"]
    player.longest_streak = data["longest_streak"]
    player.correct_answers = data["correct_answers"]
    player.games_played = data["games_played"]
    player.lifelines = Lifelines.from_h(data["lifelines"])
    player
  end
end
