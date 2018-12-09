require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/valid_placement'
require './lib/turn'
require './lib/computer_brain'
require 'pry'

class ComputerBrainTest < Minitest::Test

  def setup
    @user_board = Board.new
    @computer_board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
    #@turn1 = Turn.new(@user_board, @computer_board)
    @comp_brain2 = ComputerBrain.new(@user_board)
  end

  # def test_it_exists
  #   assert_instance_of ComputerBrain, @comp_brain
  # end
  #
  # def test_it_has_initial_key_array
  #   assert_equal 16, @comp_brain.available_keys.count
  # end
  #
  # def test_it_generates_valid_random_key
  #   @user_board.place(@cruiser, ["A1", "A2", "A3"])
  #   rand_key = @comp_brain.generate_random_attack_key
  #   assert_equal true, @user_board.cells.member?(rand_key)
  # end
  #
  # def test_it_remembers_attacked_random_key
  #   @user_board.place(@cruiser, ["A1", "A2", "A3"])
  #   rand_attack_key = @comp_brain.generate_random_attack_key
  #   assert_equal false, @user_board.cells[rand_attack_key].fired_upon?
  #
  #   @comp_brain.computer_attacks(rand_attack_key)
  #   assert_equal true, @user_board.cells[rand_attack_key].fired_upon?
  #   assert_equal false, @comp_brain.available_keys.include?(rand_attack_key)
  # end
  #
  # def test_it_smart_attacks_random_first
  #   #Attacked_keys starts empty
  #   @user_board.place(@cruiser, ["A1", "A2", "A3"])
  #   assert_equal [], @comp_brain.attacked_keys
  #
  #   #Attacked_keys now holds a random key
  #   @comp_brain.computer_attacks
  #   assert_equal 1, @comp_brain.attacked_keys.count
  # end

  # def test_it_random_attacks_after_miss
  #   @user_board.place(@cruiser, ["A1", "A2", "A3"])
  #   @comp_brain.computer_attacks("B2")
  #   p @comp_brain.attacked_keys
  #   @comp_brain.computer_attacks
  #   p @comp_brain.attacked_keys
  #   assert_equal 2, @comp_brain.attacked_keys.count
  # end

  def test_it_smart_attacks
    @user_board2 = Board.new(8, 8)
    @comp_brain = ComputerBrain.new(@user_board2)
    @user_board2.place(@submarine, ["B1", "B2"])
    @user_board2.place(@submarine, ["B3", "B4"])
    @user_board2.place(@cruiser, ["D3", "E3", "F3"])
    #puts @user_board2.render(true)

    @comp_brain.computer_attacks("B1")
    @comp_brain.computer_attacks
    assert_equal ["B1", "A1"], @comp_brain.attacked_keys
    @comp_brain.computer_attacks
    assert_equal ["B1", "A1", "C1"], @comp_brain.attacked_keys
    @comp_brain.computer_attacks
    assert_equal ["B1", "A1", "C1", "B2"], @comp_brain.attacked_keys
    @comp_brain.computer_attacks("B3")
    @comp_brain.computer_attacks
    assert_equal ["B1", "A1", "C1", "B2", "B3", "A3"], @comp_brain.attacked_keys
    @comp_brain.computer_attacks
    assert_equal ["B1", "A1", "C1", "B2", "B3", "A3", "C3"], @comp_brain.attacked_keys
    @comp_brain.computer_attacks
    assert_equal ["B1", "A1", "C1", "B2", "B3", "A3", "C3", "B4"], @comp_brain.attacked_keys
    #Should show 2 sunken ships
    puts @user_board2.render(true)
    #
    # @user_board.place(@submarine, ["D2", "D3"])
    # @comp_brain.computer_attacks("D2")
    # @comp_brain.computer_attacks
    # assert_equal ["A2", "B2", "D2", "C2"], @comp_brain.attacked_keys
  end

    # @comp_brain.computer_attacks(rand_attack_key)
    # assert_equal true, @user_board.cells[rand_attack_key].fired_upon?
    # assert_equal false, @comp_brain.available_keys.include?(rand_attack_key)
  # end



end
