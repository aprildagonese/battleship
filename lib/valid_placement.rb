class ValidPlacement



  def valid_placement?(ship, coordinates)
    if !valid_size?(ship, coordinates)
      false
    elsif !(matching?(split_letters(coordinates)) && !matching?(split_numbers(coordinates)) && consecutive?(split_numbers(coordinates)))
      false
    elsif !(!matching?(split_letters(coordinates)) && matching?(split_numbers(coordinates)) && consecutive?(split_letters(coordinates)))
      false
    else
      true
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
