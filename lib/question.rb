require 'json'
require_relative 'scoring'
require_relative 'timer'

class Question
  def initialize(song, mode, difficulty, player)
    @song = song
    @mode = mode
    @difficulty = difficulty
    @player = player
    @all_songs = load_all_songs
  end

  def ask
    timer = Timer.new(@difficulty)
    answer, prompt, type = build_question
    error_message = nil

    loop do
      system("cls") || system("clear")

      puts prompt
      puts color("\n⏱ Time left: #{timer.remaining}s", 33)

      lifelines = []
      lifelines << "[H]int" if @player.lifelines.hint
      lifelines << "[S]kip" if @player.lifelines.skip
      puts "Lifelines: #{lifelines.join(' ')}" unless lifelines.empty?

      puts "(Type 'exit' to return to the main menu)"

      if error_message
        puts color("❌ #{error_message}", 31)
        error_message = nil
      end

      print "#{@player.name}, your answer: "
      input = gets.chomp.strip

      return :exit_to_menu if input.downcase == "exit"

      if timer.expired?
        puts color("\n⏰ Time's up!", 31)
        Scoring.wrong(@player)
        break
      end

      if input.empty?
        error_message = "Answer cannot be empty."
        next
      end

      case input.downcase
      when "h"
        if @player.lifelines.hint
          hint = @song["hints"]&.sample || "No hint available"
          puts color("💡 Hint: #{hint} (-3 points)", 36)
          @player.score -= 3
          @player.lifelines.hint = false
          sleep 1.5
        else
          error_message = "No hint left."
        end
        next

      when "s"
        if @player.lifelines.skip
          puts color("⏭ Skipped.", 36)
          @player.lifelines.skip = false
          break
        else
          error_message = "No skip left."
          next
        end
      end

      correct =
        if type == :multiple_choice
          unless %w[A B C D].include?(input.upcase)
            error_message = "Please choose A, B, C or D."
            next
          end
          input.upcase == answer
        else
          text_correct?(input, answer)
        end

      if correct
        bonus = [timer.remaining / 4, 5].min
        Scoring.correct(@player, @difficulty)
        @player.score += bonus
        puts color("\n✅ Correct! +#{bonus} time bonus", 32)
      else
        puts color("\n❌ Wrong!", 31)
        puts "Correct answer: #{answer}"
        Scoring.wrong(@player)
      end

      break
    end

    puts "\nScore: #{@player.score} | Streak: #{@player.streak}"
    print "\nPress ENTER to continue..."
    gets
    :answered
  end

  def build_question
    case @mode
    when "Guess the Artist"
      artists = @all_songs.map { |s| s["artist"] }.uniq
      mapping, correct = build_multiple_choice(@song["artist"], artists)

      prompt = "🎤 Guess the ARTIST\nSong: #{@song['title']}\n\n"
      mapping.each { |k, v| prompt += "#{k}) #{v}\n" }

      [correct, prompt, :multiple_choice]

    when "Year Guess"
      years = @all_songs.map { |s| s["year"].to_s }.uniq
      mapping, correct = build_multiple_choice(@song["year"].to_s, years)

      prompt = "📅 Guess the YEAR\n#{@song['title']} by #{@song['artist']}\n\n"
      mapping.each { |k, v| prompt += "#{k}) #{v}\n" }

      [correct, prompt, :multiple_choice]

    when "Guess the Song Title"
      [
        @song["title"],
        "🎵 Guess the SONG TITLE\nArtist: #{@song['artist']}",
        :text
      ]

    when "Album Guess"
      [
        @song["album"],
        "💿 Guess the ALBUM\n#{@song['title']} by #{@song['artist']}",
        :text
      ]

    else
      [
        @song["artist"],
        "🎲 Mixed Mode\nSong: #{@song['title']}",
        :text
      ]
    end
  end

  def build_multiple_choice(correct, pool)
    options = ([correct] + pool.reject { |x| x == correct }.sample(3)).shuffle
    labels = %w[A B C D]
    mapping = {}

    options.each_with_index do |opt, i|
      mapping[labels[i]] = opt
    end

    [mapping, labels.find { |l| mapping[l] == correct }]
  end

  def text_correct?(input, answer)
    a = normalize(input)
    b = normalize(answer)

    return true if a == b

    max_distance = b.length <= 6 ? 1 : 2
    levenshtein_distance(a, b) <= max_distance
  end

  def normalize(text)
    text.to_s.downcase.gsub(/\s+/, "")
  end

  def levenshtein_distance(a, b)
    dp = Array.new(a.length + 1) { |i| [i] + [0] * b.length }
    (0..b.length).each { |j| dp[0][j] = j }

    (1..a.length).each do |i|
      (1..b.length).each do |j|
        cost = a[i - 1] == b[j - 1] ? 0 : 1
        dp[i][j] = [
          dp[i - 1][j] + 1,
          dp[i][j - 1] + 1,
          dp[i - 1][j - 1] + cost
        ].min
      end
    end

    dp[a.length][b.length]
  end

  def load_all_songs
    path = File.join(__dir__, "../data/songs.json")
    JSON.parse(File.read(path))
  end

  def color(text, code)
    "\e[#{code}m#{text}\e[0m"
  end
end
