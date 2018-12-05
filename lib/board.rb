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

end
