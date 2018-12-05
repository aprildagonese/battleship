require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'

class BoardTest < Minitest::Test

  def setup
    @board = Board.new
  end

  def test_board_exists
    assert_instance_of Board, @board
  end

  def test_cells
    assert_equal Hash, @board.cells.class
    assert_equal 16, @board.cells.length
    assert_instance_of Cell, @board.cells["A1"]
  end

  def test_calculate_character
    assert_equal ["A", "B", "C", "D"], @board.rows_array
  end

  def test_valid_coordinate_default_board
    assert_equal true, @board.valid_coordinate?("A1")
    assert_equal true, @board.valid_coordinate?("D4")
    assert_equal false, @board.valid_coordinate?("A5")
    assert_equal false, @board.valid_coordinate?("E1")
    assert_equal false, @board.valid_coordinate?("A22")
  end

  def test_valid_coordinate_custom_board
    board2 = Board.new(6, 7)
    assert_equal true, board2.valid_coordinate?("A1")
    assert_equal true, board2.valid_coordinate?("E5")
    assert_equal false, board2.valid_coordinate?("L2")
    assert_equal false, board2.valid_coordinate?("E8")
    assert_equal false, board2.valid_coordinate?("Z77")
  end

  def test_valid_placement
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)

    assert_equal false, @board.valid_placement?(cruiser,["A1", "A2"])
    assert_equal false, @board.valid_placement?(submarine,["A2", "A3", "A4"])
    assert_equal false, @board.valid_placement?(cruiser,["A1", "A2", "A4"])
    assert_equal false, @board.valid_placement?(submarine,["A1", "C1"])
    assert_equal false, @board.valid_placement?(cruiser,["A3", "A2", "A1"])
    assert_equal false, @board.valid_placement?(submarine,["C1", "B1"])
  
  end

end
