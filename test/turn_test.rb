require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/valid_placement'
require './lib/turn'
require 'pry'

class TurnTest < Minitest::Test

  def setup
    @user_board = Board.new
    @computer_board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
    @turn1 = Turn.new(@user_board, @computer_board)
  end

  def test_it_exists
    assert_instance_of Turn, @turn1
  end

  def test_it_displays_boards
    @user_board.place(@cruiser, ["A1", "A2", "A3"])
    @computer_board.place(@submarine, ["A2", "A3"])
    assert_equal "  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . . \n", @turn1.display_user_board
    assert_equal "  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n", @turn1.display_computer_board
  end

  def test_it_can_get_coords_from_player
    skip
    assert_equal "A1", @turn1.get_coords
  end

  def test_it_attacks_valid
    @user_board.place(@cruiser, ["A1", "A2", "A3"])
    @computer_board.place(@submarine, ["A2", "A3"])
    assert_equal false, @computer_board.cells["A2"].fired_upon?

    @turn1.player_attacks(@turn1.get_coords)
    assert_equal true, @computer_board.cells["A2"].fired_upon?
    p @turn1.display_computer_board
  end

  def test_it_attacks_invalid
    @user_board.place(@cruiser, ["A1", "A2", "A3"])
    @computer_board.place(@submarine, ["A2", "A3"])
    assert_equal false, @computer_board.cells["A2"].fired_upon?

    hit_cell = @computer_board.cells["A2"]
    hit_cell.fire_upon
    @turn1.player_attacks(@turn1.get_coords)
    assert_equal true, @computer_board.cells["A2"].fired_upon?
    p @turn1.display_computer_board
  end

  def test_it_generates_computer_shot
  end

end
