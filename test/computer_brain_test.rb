require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/valid_placement'
require './lib/turn'
require './lib/computer_brain'

class ComputerBrainTest < Minitest::Test

  def setup
    @user_board = Board.new
    @computer_board = Board.new
    @user_board2 = Board.new(8)
    @computer_board2 = Board.new(8)
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
    @submarine2 = Ship.new("Submarine", 2)
    @comp_brain = ComputerBrain.new(@user_board, @computer_board)
    @comp_brain2 = ComputerBrain.new(@user_board2, @computer_board2)
  end

  def test_it_exists
    assert_instance_of ComputerBrain, @comp_brain
  end

  ##Computer ship placement test methods
  def test_it_has_limited_initial_placement_array
    ship = @cruiser
    ship2 = @submarine

    assert_equal 4, @comp_brain.make_limited_placement_array(ship).count
    assert_equal 9, @comp_brain.make_limited_placement_array(ship2).count
    assert_equal "A1", @comp_brain.make_limited_placement_array(ship2).first
    assert_equal "C3", @comp_brain.make_limited_placement_array(ship2).last
  end

  def test_it_can_make_potential_keys_in_a_direction
    ship = @cruiser
    ship2 = @submarine

    assert_equal ["A1", "B1", "C1"], @comp_brain.vertical_directional_keys("A", 1, ship)
    assert_equal ["B2", "B3", "B4"], @comp_brain.horizontal_directional_keys("B", 2, ship)
    assert_equal ["C5", "D5"], @comp_brain.vertical_directional_keys("C", 5, ship2)
    assert_equal ["C5", "C6"], @comp_brain.horizontal_directional_keys("C", 5, ship2)
  end

  def test_it_can_validate_direction
    @computer_board.place(@submarine, ["C3", "D3"])
    @comp_brain.validated_keys = ["C3", "D3"]
    ship = @cruiser

    assert_equal false, @comp_brain.directional_validation("C1", :horizontal, ship)
    assert_equal false, @comp_brain.directional_validation("A3", :vertical, ship)
    assert_equal ["B2", "B3", "B4"], @comp_brain.directional_validation("B2", :horizontal, ship)
    assert_equal ["B2", "C2", "D2"], @comp_brain.directional_validation("B2", :vertical, ship)
  end

  def test_it_can_invalidate_occupied_cells
    @computer_board.place(@submarine, ["C3", "D3"])
    @comp_brain.validated_keys = ["C3", "D3"]

    assert_equal false, @comp_brain.valid_potential_keys?(["C2", "C3", "C4"])
    assert_equal false, @comp_brain.valid_potential_keys?(["A3", "B3", "C3"])
    assert_equal true, @comp_brain.valid_potential_keys?(["B2", "B3", "B4"])
    assert_equal true, @comp_brain.valid_potential_keys?(["B2", "C2", "D2"])
  end

  def test_it_can_place_ships
    @destroyer = Ship.new("Destroyer", 4)
    @battleship = Ship.new("Battelship", 5)
    @battleship2 = Ship.new("Battelship", 5)
    @battleship3 = Ship.new("Battelship", 5)
    @cruiser2 = Ship.new("cruiser", 3)
    @cruiser3 = Ship.new("cruiser", 3)
    ships = [@submarine, @cruiser, @destroyer, @battleship, @cruiser2, @cruiser3, @battleship2, @battleship3]
    @comp_brain2.cpu_place_ships(ships)
    #Un-comment line below ot visualize ships being placed
    #puts @computer_board2.render(true)
  end

  ##Computer attack method tests
  def test_it_has_initial_key_array
    assert_equal 16, @comp_brain.available_keys.count
  end

  def test_it_generates_valid_random_key
    @user_board.place(@cruiser, ["A1", "A2", "A3"])
    rand_key = @comp_brain.generate_random_attack_key
    assert_equal true, @user_board.cells.member?(rand_key)
  end

  def test_it_remembers_attacked_random_key
    @user_board.place(@cruiser, ["A1", "A2", "A3"])
    rand_attack_key = @comp_brain.generate_random_attack_key
    assert_equal false, @user_board.cells[rand_attack_key].fired_upon?

    @comp_brain.computer_attacks(rand_attack_key)
    assert_equal true, @user_board.cells[rand_attack_key].fired_upon?
    assert_equal false, @comp_brain.available_keys.include?(rand_attack_key)
  end

  def test_it_smart_attacks_random_first
    #Attacked_keys starts empty
    @user_board.place(@cruiser, ["A1", "A2", "A3"])
    assert_equal [], @comp_brain.attacked_keys

    #Attacked_keys now holds a random key
    @comp_brain.computer_attacks
    assert_equal 1, @comp_brain.attacked_keys.count
  end

  def test_it_random_attacks_after_miss
    @user_board.place(@cruiser, ["A1", "A2", "A3"])
    @comp_brain.computer_attacks("B2")
    @comp_brain.attacked_keys
    @comp_brain.computer_attacks
    @comp_brain.attacked_keys
    assert_equal 2, @comp_brain.attacked_keys.count
  end

  def test_it_moderately_smart_attacks
    @user_board2.place(@submarine, ["B1", "B2"])
    @user_board2.place(@submarine2, ["B3", "B4"])
    @user_board2.place(@cruiser, ["D3", "E3", "F3"])

    @comp_brain2.computer_attacks("B1")
    @comp_brain2.computer_attacks
    assert_equal ["B1", "A1"], @comp_brain2.attacked_keys

    @comp_brain2.computer_attacks
    assert_equal ["B1", "A1", "C1"], @comp_brain2.attacked_keys

    assert_equal "B1", @comp_brain2.find_last_hit

    @comp_brain2.computer_attacks
    assert_equal ["B1", "A1", "C1", "B2"], @comp_brain2.attacked_keys
    #starts random generation after that sink, so forcing next attack below
    @comp_brain2.computer_attacks("B3")
    assert_equal ["B1", "A1", "C1", "B2", "B3"], @comp_brain2.attacked_keys
    @comp_brain2.computer_attacks
    assert_equal ["B1", "A1", "C1", "B2", "B3", "A3"], @comp_brain2.attacked_keys
    @comp_brain2.computer_attacks
    assert_equal ["B1", "A1", "C1", "B2", "B3", "A3", "C3"], @comp_brain2.attacked_keys
    @comp_brain2.computer_attacks
    assert_equal ["B1", "A1", "C1", "B2", "B3", "A3", "C3", "B4"], @comp_brain2.attacked_keys
  end

  def test_it_smarter_attacks
    @battleship = Ship.new("Battelship", 5)
    @user_board2.place(@submarine, ["B1", "B2"])
    @user_board2.place(@submarine2, ["B3", "B4"])
    @user_board2.place(@battleship, ["C8", "D8", "E8", "F8", "G8"])

    @comp_brain2.computer_attacks("E8")
    @comp_brain2.computer_attacks
    assert_equal ["E8", "D8"], @comp_brain2.attacked_keys

    @comp_brain2.computer_attacks
    assert_equal ["E8", "D8", "C8"], @comp_brain2.attacked_keys

    @comp_brain2.computer_attacks
    assert_equal ["E8", "D8", "C8", "B8"], @comp_brain2.attacked_keys

    @comp_brain2.computer_attacks
    @comp_brain2.computer_attacks
    assert_equal ["E8", "D8", "C8", "B8", "F8", "G8"], @comp_brain2.attacked_keys

    #un-comment below line to visualize attacks
    #puts @user_board2.render(true)
  end

end
