require 'pry'
require './lib/cell'

class Board


  def initialize(width = 4, height = 4)
    @width = width #width is for numbers
    @height = height #height is for letters
    # @cells = {}
  end

  def rows_array
    end_letter = (@height + 64).chr
    rows_array = ("A"..end_letter).to_a
  end #can separate into two methods later

  def cells #mentor says to return to this for refactoring
    some_other_hash = {}

    numbers_array = (1..@width).to_a
    rows_array.each do |letter|
      numbers_array.each do |number|
        temp_key = "#{letter}#{number.to_s}"
        some_other_hash[temp_key] = Cell.new(temp_key)
      end
    end
    some_other_hash
  end

end
