# require 'pry'
# require './lib/ship'

class ValidPlacement

  def initialize
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

  def consecutive_letters?(coord_array)
    coord_array.sort.each_cons(2).all? do |a, b|
      b.ord == a.ord + 1
    end
  end

  def consecutive_numbers?(coord_array)
    coord_array.sort.each_cons(2).all? do |a, b|
      b == a.to_i + 1
    end
  end

  def valid_matching_letters?(coordinates)
    letters = split_letters(coordinates)
    numbers = split_numbers(coordinates)
    matching?(letters) && !matching?(numbers) && consecutive_numbers?(numbers)
  end

  def valid_matching_numbers?(coordinates)
    letters = split_letters(coordinates)
    numbers = split_numbers(coordinates)
    (!matching?(letters)) && matching?(numbers) && consecutive_letters?(letters)
  end

  def valid_placement?(ship, coordinates)
    if valid_size?(ship, coordinates)
      if valid_matching_letters?(coordinates) || valid_matching_numbers?(coordinates)
        true
      else
        false
      end
    else
      false
    end
  end

end
