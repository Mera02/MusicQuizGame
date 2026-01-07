require 'json'
require_relative 'player'
require_relative 'quiz_engine'

class SaveLoad
  FILE = 'data/savegame.json'

  def self.save(engine)
    data = engine.to_h
    File.write(FILE, JSON.pretty_generate(data))
  end

  def self.load
    return nil unless File.exist?(FILE)

    raw = File.read(FILE).strip
    return nil if raw.empty?

    data = JSON.parse(raw)
    QuizEngine.from_h(data)
  end
end
