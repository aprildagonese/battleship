require 'pry'
require './lib/cell'

class Board

  def initialize(height = 4, width = 4)
    @width = width #width is for numbers
    @height = height #height is for letters
  end

  def rows_array
    end_letter = (@height + 64).chr
    ("A"..end_letter).to_a
  end #refactor this later

  def cells #refactor this later
    cells_hash = {}
    numbers_array = (1..@width).to_a
    rows_array.each do |letter|
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

  def valid_placement?(ship, coordinates)
    if valid_size?(ship, coordinates)
      true
    elsif matching?(split_letters(coordinates)) && !matching?(split_numbers(coordinates)) && consecutive?(split_numbers(coordinates))
      true
    elsif !matching?(split_letters(coordinates)) && matching?(split_numbers(coordinates)) && consecutive?(split_letters(coordinates))
      true
    else
      false
    end
  end

  def valid_size?(ship, coordinates)
    ship.length == coordinates.count
  end

  def split_letters(coordinates)
    coordinates.map do |coordinate|
      coordinate[0]
    end
  end

  def split_numbers(coordinates)
    coordinates.map do |coordinate|
      coordinate[1].to_i
    end
  end

  def matching?(coord_array)
    coord_array.uniq.count == 1
  end

  def consecutive?(coord_array)
    coord_array.sort.each_cons(2).all? do |a, b|
      b == a + 1
    end
  end

end
