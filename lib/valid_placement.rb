# require 'pry'
# require './lib/ship'

class ValidPlacement

  def initialize(ship, coordinates)
    @ship = ship
    @coordinates = coordinates
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
    matching?(split_letters(coordinates)) && !matching?(split_numbers(coordinates)) && consecutive_numbers?(split_numbers(coordinates))
  end

  def valid_matching_numbers?(coordinates)
    (!matching?(split_letters(coordinates))) && matching?(split_numbers(coordinates)) && consecutive_letters?(split_letters(coordinates))
  end


  # def valid_placement2?
  #   if valid_size?(ship, coordinates) && valid_matching_letters?(coordinates) && valid_matching_numbers?(coordinates)
  #     true
  #   else
  #     false
  #   end
  # end
  #
  # def valid_size?(ship, coordinates)
  #   ship.length == coordinates.count
  # end
  #
  # def split_letters(coordinates)
  #   coordinates.map do |coordinate|
  #     coordinate[0]
  #   end
  # end
  #
  # def split_numbers(coordinates)
  #   coordinates.map do |coordinate|
  #     coordinate[1].to_i
  #   end
  # end
  #
  # def matching?(coord_array)
  #   coord_array.uniq.count == 1
  # end
  #
  # def consecutive?(coord_array)
  #   coord_array.sort.each_cons(2).all? do |a, b|
  #     b == a + 1
  #   end
  # end
  #
  # def valid_matching_letters?(coordinates)
  #   matching?(split_letters(coordinates)) && !matching?(split_numbers(coordinates)) && consecutive?(split_numbers(coordinates))
  # end
  #
  # def valid_matching_numbers?(coordinates)
  #   !matching?(split_letters(coordinates)) && matching?(split_numbers(coordinates)) && consecutive?(split_letters(coordinates))
  # end


end

# test_array2 = ["A1", "B1", "C1", "D1"]
# cruiser = Ship.new("Cruiser", 3)
# placement = ValidPlacement.new(cruiser, test_array2)
# placement.valid_matching_numbers?(test_array2)
