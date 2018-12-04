class Ship
  attr_reader :name, :length, :hits

  def initialize(name, length)
    @name = name
    @length = length
    @hits = 0
  end

  def health
    @length - @hits
  end

  def sunk?
    health == 0
  end

  def hit
    @hits +=1
  end




end
