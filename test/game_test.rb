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

class ComputerBrainTest < Minitest::Test

  def setup
    @user_board = Board.new
    @computer_board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
    @submarine2 = Ship.new("Submarine", 2)
    @turn1 = Turn.new(@user_board, @computer_board)
    @comp_brain = ComputerBrain.new(@user_board)
    @game = Game.new
  end

  def test_it_makes_custom_ships
    make_custom_ships
  end
end
