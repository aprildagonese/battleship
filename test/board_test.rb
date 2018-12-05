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

  def test_board_creation
    assert_equal true, @board.cells.member?("D4")
  end

  def test_sad_path_board_creation
    skip
    #maybe we don't let the user make a @board past Z?

  end

  def test_when_cell_is_valid
    skip
  end

  def test_when_cell_is_invalid
    skip
  end

end
