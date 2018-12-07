require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/valid_placement'
require 'pry'

class ValidPlacementTest < Minitest::Test

  def setup
    @placement = ValidPlacement.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
  end

  def test_it_exists
    assert_instance_of ValidPlacement, @placement
  end

  def test_valid_size
    assert_equal false, @placement.valid_size?(@cruiser,["A1", "A2"])
    assert_equal false, @placement.valid_size?(@submarine,["A2", "A3", "A4"])
    assert_equal true, @placement.valid_size?(@submarine,["A2", "A3"])
  end

  def test_split_letters
    test_array = ["A2", "B2", "C2", "D2"]
    assert_equal ["A", "B", "C", "D"], @placement.split_letters(test_array)
  end

  def test_split_numbers
    test_array = ["A3", "A1", "A2", "A4"]
    assert_equal [3, 1, 2, 4], @placement.split_numbers(test_array)
  end

  def test_matching_letters
    test_array1 = ["A3", "A1", "A2", "A4"]
    test_letters1 = @placement.split_letters(test_array1)
    assert_equal true, @placement.matching?(test_letters1)
    test_array2 = ["A2", "A2", "C2", "D2"]
    test_letters2 = @placement.split_letters(test_array2)
    assert_equal false, @placement.matching?(test_letters2)
  end

  def test_matching_numbers
    test_array1 = ["A3", "A1", "A2", "A4"]
    test_numbers1 = @placement.split_numbers(test_array1)
    assert_equal false, @placement.matching?(test_numbers1)
    test_array2 = ["A2", "A2", "C2", "D2"]
    test_numbers2 = @placement.split_numbers(test_array2)
    assert_equal true, @placement.matching?(test_numbers2)
  end

  def test_consecutive_numbers
    test_array = ["A1", "A2", "A3", "A4"]
    test_numbers = @placement.split_numbers(test_array)
    assert_equal true, @placement.consecutive_numbers?(test_numbers)
  end

  def test_consecutive_numbers_sort
    test_array = ["A3", "A1", "A2", "A4"]
    test_numbers = @placement.split_numbers(test_array)
    assert_equal true, @placement.consecutive_numbers?(test_numbers)
  end

  def test_consecutive_letters
    test_array = ["A2", "B2", "C2", "D2"]
    test_numbers = @placement.split_letters(test_array)
    assert_equal true, @placement.consecutive_letters?(test_numbers)
  end

  def test_consecutive_letters_sort
    test_array = ["D2", "A2", "B2", "C2"]
    test_numbers = @placement.split_letters(test_array)
    assert_equal true, @placement.consecutive_letters?(test_numbers)
  end

  def test_consecutive_failure
    test_array1 = ["D2", "A2", "B2"]
    test_numbers1 = @placement.split_letters(test_array1)
    assert_equal false, @placement.consecutive_letters?(test_numbers1)
    test_array2 = ["A1", "A2", "A4"]
    test_numbers2 = @placement.split_numbers(test_array2)
    assert_equal false, @placement.consecutive_numbers?(test_numbers2)
  end

  def test_valid_combinations
    test_array1 = ["A1", "A2", "A3", "A4"]
    assert_equal true, @placement.valid_matching_letters?(test_array1)
    test_array2 = ["A1", "B1", "C1", "D1"]
    assert_equal true, @placement.valid_matching_numbers?(test_array2)
    test_array3 = ["B1", "B2", "B3", "B4"]
    assert_equal false, @placement.valid_matching_numbers?(test_array3)
  end

  def test_invalid_placement_not_correct_length
    assert_equal false, @placement.valid_placement?(@cruiser,["A1", "A2"])
    assert_equal false, @placement.valid_placement?(@submarine,["A2", "A3", "A4"])
  end

  def test_invalid_placement_not_consecutive
    assert_equal false, @placement.valid_placement?(@cruiser,["A1", "A2", "A4"])
    assert_equal false, @placement.valid_placement?(@submarine,["A1", "C1"])
  end

  def test_invalid_placement_diagonal
    assert_equal false, @placement.valid_placement?(@cruiser,["A1", "B2", "C3"])
    assert_equal false, @placement.valid_placement?(@submarine,["C2", "D3"])
  end

  def test_valid_placement
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)
    assert_equal true, @placement.valid_placement?(submarine,["A1", "A2"])
    assert_equal true, @placement.valid_placement?(cruiser,["B1", "C1", "D1"])
  end



end
