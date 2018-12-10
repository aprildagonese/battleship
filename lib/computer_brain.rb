require './lib/board'
require 'pry'

class ComputerBrain
  attr_accessor :attacked_keys, :available_keys

  def initialize(user_board)
    @user_board = user_board
    @attacked_keys = []
    @available_keys = @user_board.cells.keys
  end

  # def computer_places_ships(ships)
  #
  # end

  def computer_attacks(key = generate_smart_attack_key)
    @user_board.cells[key].fire_upon
    @available_keys.delete(key)
    @attacked_keys << key
  end

  # def evaluate_smart_attack_history
  #   index = -1
  #   last_key = @attacked_keys[index]
  #   second_last_key = @attacked_keys[-2]
  #   @attacked_keys.each do |key|
  #     if @user_board.cells[key].render == "M"
  #       index -= 1
  #     else

  def find_last_hit
    last_key = 12
    last_hit = @attacked_keys.reverse[0..3].find do |key|
      @user_board.cells[key].render == "H"
    end

    if last_hit.nil?
      last_key = @attacked_keys.last
    else
      last_key = last_hit
    end
    last_key
  end

  def generate_random_attack_key
    key_index = rand(@available_keys.size) - 1
    @available_keys[key_index]
  end

  def generate_smart_attack_key
    # last_key = @attacked_keys.last
    last_key = find_last_hit
    if @attacked_keys.empty? || @user_board.cells[last_key].render == "X" || @user_board.cells[last_key].render == "M"

      generate_random_attack_key

    elsif @user_board.cells[last_key].render == "H"
      last_letter = last_key.split("")[0].ord
      last_number = last_key.split("")[1].to_i
      #moves up
      if last_letter > 65
        next_letter = (last_letter - 1).chr
        next_key = "#{next_letter}#{last_number}"
        #binding.pry
        if !@attacked_keys.include?(next_key)
          return next_key
        end
      end

      #moves down
    elsif last_letter < (@user_board.height + 63)
      next_letter = (last_letter + 1).chr
      next_key = "#{next_letter}#{last_number}"
      #binding.pry
      if !@attacked_keys.include?(next_key)
        return next_key
      end

    #moves left
    elsif last_number > 1
      next_number = last_number - 1
      next_key = "#{last_letter.chr}#{next_number}"
      if !@attacked_keys.include?(next_key)
        return next_key
      end

      #moves right
    elsif last_number < (@user_board.width)
      next_number = last_number + 1
      next_key = "#{last_letter.chr}#{next_number}"
      if !@attacked_keys.include?(next_key)
        return next_key
      end

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
