require 'pry'
require './lib/cell'

class Board

  def initialize(width, height)
    @width = width #width is for numbers
    @height = height #height is for letters
    # @cells = {}
  end

  def rows_array
    end_letter = (@height + 64).chr
    rows_array = ("A"..((@height + 64).chr).to_a
  end

  def cells
    some_other_hash = {}

    numbers_array = (1..@width).to_a
    rows_array.each do |letter|
      numbers_array.each do |number|
        temp_key = "#{letter}#{number.to_s}"
        some_other_hash[temp_key] = Cell.new(temp_key)
      end
    end
    return some_other_hash
  end

end
