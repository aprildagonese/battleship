require 'pry'

class ComputerBrain
  attr_accessor :placed_keys, :attacked_keys, :available_keys

  def initialize(user_board, cpu_board)
    @user_board = user_board
    @cpu_board = cpu_board
    @placed_keys = []
    @attacked_keys = []
    @available_keys = @user_board.cells.keys

  end

  ##Computer place methods
  def make_limited_placement_array(ship)
    length = ship.length
    max_width = @cpu_board.width - length + 1
    max_height = (@cpu_board.height - length + 65).chr

    potential_first_keys = []
    ("A"..max_height).to_a.each do |letter|
      (1..max_width).to_a.each do |number|
        potential_first_keys << "#{letter}#{number}"
      end
    end
    return potential_first_keys
  end

  def directional_search(coordinate, direction, ship)
    letter = coordinate.split("")[0]
    number = coordinate.split("")[1].to_i
    potential_keys = []

    if direction == :vertical
      end_letter = (letter.ord + ship.length - 1).chr
      test_range = (letter..end_letter).to_a
      test_range.each do |dyn_letter|
        potential_keys << "#{dyn_letter}#{number}"
      end
      potential_keys.all? do |key|
        @cpu_board.cells[key].empty?
      end

    elsif direction == :horizontal
      end_number = number + ship.length - 1
      test_range = (number..end_number).to_a
      test_range.each do |dyn_number|
        potential_keys << "#{letter}#{dyn_number}"
      end
      potential_keys.all? do |key|
        @cpu_board.cells[key].empty?
      end
    end

  end

  def cpu_place_ships(ships)
    placed_keys = []
    ships.each do |ship|
    end
  end


  ##Computer attack methods

  def computer_attacks(key = generate_smart_attack_key)
    @user_board.cells[key].fire_upon
    @available_keys.delete(key)
    @attacked_keys << key
  end

  def generate_smart_attack_key
    last_key = find_last_hit
    if @attacked_keys.empty? || last_key == nil || @user_board.cells[last_key].render == "X"
      generate_random_attack_key
    elsif @user_board.cells[last_key].render == "H"
      last_letter = last_key.split("")[0].ord
      last_number = last_key.split("")[1].to_i
      move_up(last_letter, last_number)
    end
  end

  def find_last_hit
    last_hit = @attacked_keys.reverse[0..3].find do |key|
      @user_board.cells[key].render == "H"
    end
    last_hit
  end

  def generate_random_attack_key
    key_index = rand(@available_keys.size) - 1
    @available_keys[key_index]
  end

  def move_up(last_letter, last_number)
    if last_letter > 65
      next_letter = (last_letter - 1).chr
      next_key = "#{next_letter}#{last_number}"
      if !@attacked_keys.include?(next_key)
        return next_key
      else
        move_down(last_letter, last_number)
      end
    else
      move_down(last_letter, last_number)
    end
  end

  def move_down(last_letter, last_number)
    if last_letter < (@user_board.height + 63)
    next_letter = (last_letter + 1).chr
    next_key = "#{next_letter}#{last_number}"
      if !@attacked_keys.include?(next_key)
        return next_key
      else
        move_left(last_letter, last_number)
      end
    else
      move_left(last_letter, last_number)
    end
  end

  def move_left(last_letter, last_number)
    if last_number > 1
    next_number = last_number - 1
    next_key = "#{last_letter.chr}#{next_number}"
      if !@attacked_keys.include?(next_key)
        return next_key
      else
        move_right(last_letter, last_number)
      end
    else
      move_right(last_letter, last_number)
    end
  end

  def move_right(last_letter, last_number)
    if last_number < (@user_board.width)
      next_number = last_number + 1
      next_key = "#{last_letter.chr}#{next_number}"
      if !@attacked_keys.include?(next_key)
        return next_key
      else
        generate_random_attack_key
      end
    else
      generate_random_attack_key
    end
  end

end


#
# user_board = Board.new
# comp_brain = ComputerBrain.new(user_board)
# @user_board.place(@cruiser, ["B1", "B2", "B3"])
# # rand_attack_key = comp_brain.generate_random_attack_key
# # p rand_attack_key
# comp_brain.computer_attacks("B2")
# smart_key = comp_brain.generate_smart_attack_key
# #smart_key
# comp_brain.computer_attacks(smart_key)
