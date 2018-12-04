require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'

class BoardTest < Minitest::Test

  def test_board_exists
    board = Board.new(4, 4)
    assert_instance_of Board, board
  end

  def test_cells
    board = Board.new(4, 4)
    assert_equal Hash, board.cells.class
    assert_equal 16, board.cells.length
    assert_instance_of Cell, board.cells["A1"]
  end

  def test_calculate_character
    board = Board.new(4, 4)
    assert_equal ["A", "B", "C", "D"], board.rows_array
  end

  def test_board_creation
    board = Board.new(4, 4)

    assert_equal true, board.cells.member?("D4")
  end

end
