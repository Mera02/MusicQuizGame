require 'json'

class Scoreboard
  FILE_PATH = 'data/scoreboard.json'

  def self.load
    return [] unless File.exist?(FILE_PATH)

    content = File.read(FILE_PATH).strip
    return [] if content.empty?

    JSON.parse(content)
  rescue JSON::ParserError
    []
  end

  def self.update(players)
    scoreboard = load

    players.each do |player|
      entry = scoreboard.find { |e| e["name"] == player.name }

      if entry
        entry["games_played"] += 1
        entry["high_score"] = [entry["high_score"], player.score].max
        entry["total_correct"] += player.correct_answers
        entry["longest_streak"] = [entry["longest_streak"], player.longest_streak].max
      else
        scoreboard << {
          "name" => player.name,
          "games_played" => 1,
          "high_score" => player.score,
          "total_correct" => player.correct_answers,
          "longest_streak" => player.longest_streak
        }
      end
    end

    File.write(FILE_PATH, JSON.pretty_generate(scoreboard))
  end

  def self.display
    scoreboard = load

    system("cls") || system("clear")
    puts "🏆 SCOREBOARD\n"

    if scoreboard.empty?
      puts "No games played yet."
      return
    end

    scoreboard
      .sort_by { |e| -e["high_score"] }
      .each_with_index do |e, i|
        puts "#{i + 1}. #{e["name"]} | High Score: #{e["high_score"]} | Games: #{e["games_played"]} | Longest Streak: #{e["longest_streak"]}"
      end
  end
end
