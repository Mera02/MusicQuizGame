require 'json'
require_relative 'question'
require_relative 'save_load'

class QuizEngine
  attr_reader :mode, :difficulty, :players, :current_player_index

  def initialize(mode, difficulty, players, current_player_index = 0, round_format)
    @mode = mode
    @difficulty = difficulty
    @players = players
    @current_player_index = current_player_index
    @round_format = round_format

    @questions_played = 0
    @rounds_played = 0

    @songs = load_songs
    @exited_to_menu = false
  end

  def play_game
    until round_over?
      play_round
      break if @exited_to_menu
    end
  end

  def play_round
    player = @players[@current_player_index]
    song = @songs.sample

    result = Question.new(song, @mode, @difficulty, player).ask

    if result == :exit_to_menu
      @exited_to_menu = true
      return
    end

    @questions_played += 1

    finished_round = advance_player

    if finished_round
      @rounds_played += 1
    end

    SaveLoad.save(self)
  end

  def exited_to_menu?
    @exited_to_menu
  end

  def round_over?
    return true if @exited_to_menu

    case @round_format[:type]
    when :fixed
      if multiplayer?
        @rounds_played >= @round_format[:value]
      else
        @questions_played >= @round_format[:value]
      end

    when :first_to_k
      @players.any? { |p| p.correct_answers >= @round_format[:value] }

    else
      false
    end
  end

  def to_h
    {
      "mode" => @mode,
      "difficulty" => @difficulty,
      "current_player_index" => @current_player_index,
      "players" => @players.map(&:to_h),
      "round_format" => @round_format,
      "questions_played" => @questions_played,
      "rounds_played" => @rounds_played
    }
  end

  def self.from_h(data)
    players = data["players"].map { |p| Player.from_h(p) }

    raw_format = data["round_format"]
    round_format = {
      type: raw_format["type"].to_sym,
      value: raw_format["value"].to_i
    }

    engine = QuizEngine.new(
      data["mode"],
      data["difficulty"],
      players,
      data["current_player_index"],
      round_format
    )

    engine.instance_variable_set(:@questions_played, data["questions_played"] || 0)
    engine.instance_variable_set(:@rounds_played, data["rounds_played"] || 0)

    engine
  end

  private

  def multiplayer?
    @players.size > 1
  end

  def advance_player
    @current_player_index += 1

    if @current_player_index >= @players.size
      @current_player_index = 0
      return true
    end

    false
  end

  def load_songs
    path = File.join(__dir__, "../data/songs.json")
    JSON.parse(File.read(path))
  end
end
