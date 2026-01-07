class Timer
  LIMITS = {
    "Easy" => 20,
    "Normal" => 15,
    "Hard" => 10
  }

  def initialize(difficulty)
    @limit = LIMITS[difficulty]
    @start = Time.now
  end

  def remaining
    rem = @limit - (Time.now - @start).to_i
    rem > 0 ? rem : 0
  end

  def expired?
    remaining <= 0
  end
end
