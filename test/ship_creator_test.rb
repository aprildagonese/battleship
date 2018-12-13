require 'minitest/autorun'
require 'minitest/pride'
require './lib/board'
require './lib/ship_creator.rb'

class ShipCreatorTest < Minitest::Test

  def setup
    @user_board = Board.new
    @create_ships = ShipCreator.new(@user_board)
  end

  def test_it_exists
    assert_instance_of ShipCreator, @create_ships
  end

  def test_it_can_get_default_ships
    @create_ships.get_default_ships
    assert_equal 2, @create_ships.cpu_ships.count
    assert_equal 2, @create_ships.user_ships.count
    assert_equal "Destroyer", @create_ships.cpu_ships[0].name
    assert_equal 2, @create_ships.cpu_ships[0].length
    assert_equal "Submarine", @create_ships.cpu_ships[1].name
    assert_equal 3, @create_ships.cpu_ships[1].length

    @user_board2 = Board.new(18)
    @create_ships2 = ShipCreator.new(@user_board2)
    @create_ships2.get_default_ships
    assert_equal 10, @create_ships2.cpu_ships.count
    assert_equal 10, @create_ships2.user_ships.count
    assert_equal "Battleship", @create_ships2.cpu_ships[3].name
    assert_equal 4, @create_ships2.cpu_ships[3].length
    assert_equal "Carrier", @create_ships2.cpu_ships[9].name
    assert_equal 5, @create_ships2.cpu_ships[9].length
  end

end
