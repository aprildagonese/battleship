class Cell
  attr_reader :coordinate, :ship

  def initialize(coordinate)
    @coordinate = coordinate
    #When place_ship method is called, call.ship will contian ship.
    @ship = nil
  end

  def empty?
    @ship.nil?
  end

  def place_ship(ship)
    @ship = ship
  end

  #Not sure what is suppoed to happen in here:
  def fired_upon?
    true
  end

  def fire_upon
    @ship.hit
  end

end
