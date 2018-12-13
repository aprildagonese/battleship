require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/valid_placement'
require './lib/turn'

class TurnTest < Minitest::Test

  def setup
    @user_board = Board.new
    @computer_board = Board.new
    @computer_brain = ComputerBrain.new(@user_board, @computer_board)
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
    @turn1 = Turn.new(@user_board, @computer_board, @computer_brain)
  end

  def test_it_exists
    assert_instance_of Turn, @turn1
  end

  def test_it_displays_boards
    @user_board.place(@cruiser, ["A1", "A2", "A3"])
    @computer_board.place(@submarine, ["A2", "A3"])

    assert_equal "  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . . \n", @user_board.render(true)
    assert_equal "  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n", @computer_board.render
  end

  def test_it_attacks_valid
    @user_board.place(@cruiser, ["A1", "A2", "A3"])
    @computer_board.place(@submarine, ["A2", "A3"])
    assert_equal false, @computer_board.cells["A2"].fired_upon?

    @turn1.player_attacks("A2")
    assert_equal true, @computer_board.cells["A2"].fired_upon?
  end

  def test_it_attacks_invalid
    @user_board.place(@cruiser, ["A1", "A2", "A3"])
    @computer_board.place(@submarine, ["A2", "A3"])
    assert_equal false, @computer_board.cells["A2"].fired_upon?

    @turn1.player_attacks("A2")
    assert_equal true, @computer_board.cells["A2"].fired_upon?
  end

end
