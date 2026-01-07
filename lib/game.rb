require_relative 'player'
require_relative 'quiz_engine'
require_relative 'scoreboard'
require_relative 'save_load'

class Game
  MODES = [
    "Guess the Song Title",
    "Guess the Artist",
    "Year Guess",
    "Album Guess",
    "Mixed"
  ]

  DIFFICULTIES = ["Easy", "Normal", "Hard"]

  def self.setup_new_game
    system("cls") || system("clear")
    puts "🎮 NEW GAME SETUP\n"

    players = setup_players
    mode = choose_option("Select Quiz Mode:", MODES)
    difficulty = choose_option("Select Difficulty:", DIFFICULTIES)
    round_format = choose_round_format

    system("cls") || system("clear")
    puts "✅ GAME CONFIGURATION\n"
    puts "Players: #{players.map(&:name).join(', ')}"
    puts "Mode: #{mode}"
    puts "Difficulty: #{difficulty}"
    puts round_format_summary(round_format)

    print "\nPress ENTER to start..."
    gets

    loop do
      engine = QuizEngine.new(mode, difficulty, players, 0, round_format)
      engine.play_game

      return if engine.exited_to_menu?

      SaveLoad.save(engine)
      Scoreboard.update(players)

      action = show_summary(players)

      case action
      when :play_again
        players.each(&:reset)
        next
      when :change_settings
        setup_new_game
        return
      when :menu
        return
      end
    end
  end

  def self.continue_game
    system("cls") || system("clear")

    engine = SaveLoad.load

    if engine.nil?
      puts "❌ No saved game found."
      sleep 1.5
      return
    end

    puts "▶ Continuing saved game..."
    sleep 1

    engine.play_game

    return if engine.exited_to_menu?

    SaveLoad.save(engine)
    Scoreboard.update(engine.players)
    show_summary(engine.players)
  end

  def self.setup_players
    loop do
      system("cls") || system("clear")
      print "Single or Multiplayer? (1/2): "
      choice = gets.chomp.strip

      if choice == "1"
        return [create_player(1)]
      elsif choice == "2"
        return [create_player(1), create_player(2)]
      else
        puts "❌ Invalid choice."
        sleep 1
      end
    end
  end

  def self.create_player(index)
    loop do
      system("cls") || system("clear")
      print "Enter name for Player #{index}: "
      name = gets.chomp.strip
      return Player.new(name) unless name.empty?
      puts "❌ Name cannot be empty."
      sleep 1
    end
  end

  def self.choose_option(title, options)
    loop do
      system("cls") || system("clear")
      puts title
      options.each_with_index { |opt, i| puts "#{i + 1}. #{opt}" }
      print "\nChoose option: "
      choice = gets.chomp.to_i
      return options[choice - 1] if choice.between?(1, options.size)
      puts "❌ Invalid choice."
      sleep 1
    end
  end

  def self.choose_round_format
    loop do
      system("cls") || system("clear")
      puts "Select Round Format:"
      puts "1. Fixed number of rounds"
      puts "2. First to K correct answers"
      print "\nChoose option: "
      choice = gets.chomp.strip

      case choice
      when "1"
        print "Enter number of rounds: "
        value = gets.chomp.to_i
        return { type: :fixed, value: value } if value > 0
      when "2"
        print "First to how many correct answers? "
        value = gets.chomp.to_i
        return { type: :first_to_k, value: value } if value > 0
      end

      puts "❌ Invalid choice."
      sleep 1
    end
  end

  def self.round_format_summary(round_format)
    round_format[:type] == :fixed ?
      "Round format: #{round_format[:value]} rounds" :
      "Round format: First to #{round_format[:value]} correct answers"
  end

  def self.show_summary(players)
    system("cls") || system("clear")

    puts "🏁 GAME OVER"
    puts "========================\n"

    players.each do |p|
      puts "#{p.name}"
      puts "  Score: #{p.score}"
      puts "  Longest streak: #{p.longest_streak}\n"
    end

    if players.size > 1
      max_score = players.map(&:score).max
      winners = players.select { |p| p.score == max_score }

      puts "========================"

      if winners.size == 1
        puts "🏆 WINNER: #{winners.first.name}!"
      else
        puts "🤝 DRAW between: #{winners.map(&:name).join(', ')}"
      end
    end

    loop do
      puts "\nWhat would you like to do next?"
      puts "1. 🔁 Play again (same settings)"
      puts "2. ⚙ Change mode or difficulty"
      puts "3. 🏠 Return to main menu"
      print "\nChoose option: "

      case gets.chomp.strip
      when "1" then return :play_again
      when "2" then return :change_settings
      when "3" then return :menu
      end
    end
  end
end
