class Lifelines
  attr_accessor :hint, :skip

  def initialize
    @hint = true
    @skip = true
  end

  def to_h
    {
      "hint" => @hint,
      "skip" => @skip
    }
  end

  def self.from_h(data)
    lifelines = Lifelines.new
    lifelines.hint = data["hint"]
    lifelines.skip = data["skip"]
    lifelines
  end
end
