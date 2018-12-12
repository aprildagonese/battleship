require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/valid_placement'
require './lib/turn'
require './lib/computer_brain'
require './lib/game.rb'
require 'pry'

class GameTest < Minitest::Test

  def setup
    @user_board = Board.new
    @computer_board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
    @submarine2 = Ship.new("Submarine", 2)
    @comp_brain = ComputerBrain.new(@user_board, @computer_board)
    @turn1 = Turn.new(@user_board, @computer_board, @comp_brain)
    @game = Game.new
  end

  def test_it_identifies_player_wins
    @computer_board.place(@submarine, ["B1", "B2"])
    @user_board.place(@submarine2, ["D1", "D2"])

    assert_equal 1, @computer_board.ships.count
    assert_equal 1, @user_board.ships.count


    @computer_board.cells["B1"].fire_upon
    @user_board.cells["B1"].fire_upon
    assert_equal false, @game.all_ships_sunk?(@user_board)
    assert_equal false, @game.all_ships_sunk?(@computer_board)

    @computer_board.cells["B2"].fire_upon
    @user_board.cells["B2"].fire_upon


    assert_equal false, @game.all_ships_sunk?(@user_board)
    assert_equal true, @game.all_ships_sunk?(@computer_board)
  end

  def test_it_identifies_computer_wins
    @computer_board.place(@submarine, ["B1", "B2"])
    @user_board.place(@submarine2, ["D1", "D2"])
    assert_equal 1, @computer_board.ships.count
    assert_equal 1, @user_board.ships.count

    assert_equal false, @game.all_ships_sunk?(@user_board)
    assert_equal false, @game.all_ships_sunk?(@computer_board)

    @computer_board.cells["D1"].fire_upon
    @user_board.cells["D1"].fire_upon
    @computer_board.cells["D2"].fire_upon
    @user_board.cells["D2"].fire_upon

    assert_equal true, @game.all_ships_sunk?(@user_board)
    assert_equal false, @game.all_ships_sunk?(@computer_board)
  end

end
