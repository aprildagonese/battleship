require './lib/cell'
require './lib/valid_placement'

class Board
  attr_reader :cells

  def initialize(height = 4, width = 4)
    @width = width #width is for numbers
    @height = height #height is for letters
    @cells = cells_hash
  end

  def letters_array
    end_letter = (@height + 64).chr
    ("A"..end_letter).to_a
  end

  def numbers_array
    (1..@width).to_a
  end #refactor this later

  def cells_hash #refactor this later
    cells_hash = {}
    letters_array.each do |letter|
      numbers_array.each do |number|
        temp_key = "#{letter}#{number.to_s}"
        cells_hash[temp_key] = Cell.new(temp_key)
      end
    end
    return cells_hash
  end

  def valid_coordinate?(coordinate)
    cells.member?(coordinate)
  end

  def overlapping_ships?(coordinates)
    coordinates.all? do |coordinate|
      cells[coordinate].empty?
    end
  end

  def valid_placement?(ship, coordinates)
    placement = ValidPlacement.new(ship, coordinates)
    placement.valid_placement?(ship, coordinates) && overlapping_ships?(coordinates)
  end

  def place(ship, coordinates)
    if valid_placement?(ship, coordinates)
      coordinates.each do |coordinate|
        cells[coordinate].place_ship(ship)
      end
    # else
    #   puts invalid_return_statement
    end
  end

  def render(show_ship = false)
    render_array(show_ship).join.to_s
  end


  def render_array(show_ship)
    render_array = []

    #render_array << " "
    numbers_array.each do |number|
      render_array << " " + number.to_s
    end
    render_array << " \n"

    letters_array.each do |letter|
      render_array << letter + " "
      numbers_array.each do |number|
        temp_key = "#{letter}#{number.to_s}"
        render_array << cells[temp_key].render(show_ship) + " "
      end
      render_array << "\n"
    end
    return render_array
  end

end
