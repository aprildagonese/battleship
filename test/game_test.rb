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
    skip 
    @computer_board.place(@submarine, ["B1", "B2"])
    @computer_board.place(@submarine2, ["C3", "C4"])
    @user_board.place(@submarine, ["A1", "A2"])
    @user_board.place(@submarine2, ["D1", "D2"])
    assert_equal 2, @computer_board.ships.count
    assert_equal 2, @user_board.ships.count


    @computer_board.cells["B1"].fire_upon
    @user_board.cells["B1"].fire_upon
    assert_equal false, @game.all_ships_sunk?(@user_board)
    assert_equal false, @game.all_ships_sunk?(@computer_board)

    @computer_board.cells["B2"].fire_upon
    @user_board.cells["B2"].fire_upon
    @computer_board.cells["C3"].fire_upon
    @user_board.cells["C3"].fire_upon
    @computer_board.cells["C4"].fire_upon
    @user_board.cells["C4"].fire_upon

    puts @user_board.ships[0].health
    puts @computer_board.ships[0].health

    assert_equal false, @game.all_ships_sunk?(@user_board)
    assert_equal true, @game.all_ships_sunk?(@computer_board)
  end

  def test_it_identifies_computer_wins
    skip
    @computer_board.place(@submarine, ["B1", "B2"])
    @computer_board.place(@submarine2, ["C3", "C4"])
    @user_board.place(@submarine, ["A1", "A2"])
    @user_board.place(@submarine2, ["D1", "D2"])
    assert_equal 2, @computer_board.ships.count
    assert_equal 2, @user_board.ships.count

    @computer_board.cells["A1"].fire_upon
    @user_board.cells["A1"].fire_upon
    assert_equal false, @game.all_ships_sunk?(@user_board)
    assert_equal false, @game.all_ships_sunk?(@computer_board)

    @computer_board.cells["A2"].fire_upon
    @user_board.cells["A2"].fire_upon
    @computer_board.cells["D1"].fire_upon
    @user_board.cells["D1"].fire_upon
    @computer_board.cells["D2"].fire_upon
    @user_board.cells["D2"].fire_upon
    puts @user_board.ships[0].health
    puts @computer_board.ships[0].health

    assert_equal true, @game.all_ships_sunk?(@user_board)
    assert_equal false, @game.all_ships_sunk?(@computer_board)
  end

end
