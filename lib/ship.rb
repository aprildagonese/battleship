class Ship
  attr_reader :name, :length

  def initialize(name, length)
    @name = name
    @length = length
  end

  def health
    hits = 0
    @length - hits
  end

  def sunk?
    health == 0
  end

  def hit
    

end
