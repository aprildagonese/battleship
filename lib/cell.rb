class Cell
  attr_reader :coordinate, :ship, :fired_upon

  def initialize(coordinate)
    @coordinate = coordinate
    #When place_ship method is called, call.ship will contian ship.
    @ship = nil
    @fired_upon = false
  end

  def empty?
    @ship.nil?
  end

  def place_ship(ship)
    @ship = ship
  end

  #Not sure what is suppoed to happen in here:
  def fired_upon?
    @fired_upon
  end

  def fire_upon
    @fired_upon = true
    if !@ship.nil?
      @ship.hit
    end
  end

  #Revisit to make easier to read/better flow
  def render(show_ship = false)
    if !fired_upon? && !empty? && show_ship
      "S"
    elsif !fired_upon? && empty?
      "."
    elsif empty?
      "M"
    elsif @ship.sunk?
      "X"
    else
      "H"
    end
  end

end
