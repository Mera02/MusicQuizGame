class Scoring
  POINTS = {
    "Easy" => 10,
    "Normal" => 15,
    "Hard" => 20
  }

  def self.correct(player, difficulty)
    player.streak += 1
    bonus = player.streak >= 3 ? 2 : 0
    player.score += POINTS[difficulty] + bonus
    player.correct_answers += 1
    player.longest_streak = [player.longest_streak, player.streak].max
  end

  def self.wrong(player)
    player.streak = 0
  end
end
