class Cell
attr_reader :cell, :ship

  def initialize(cell)
    @cell = cell
    @ship = nil
  end

  def empty?
    @ship == nil
  end

  def place_ship(ship)
    @ship = ship
  end

  def fired_upon?
    @ship.hits > 0
  end

  def fire_upon
    @ship.hit
  end

end
