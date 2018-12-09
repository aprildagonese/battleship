require './lib/board'
class ComputerBrain
  attr_accessor :attacked_keys, :available_keys

  def initialize(user_board)
    @user_board = user_board
    @attacked_keys = []
    @available_keys = @user_board.cells.keys
  end

  def generate_random_attack_key
    key_index = rand(@available_keys.size) - 1
    @available_keys[key_index]
  end

  def computer_attacks(key = generate_smart_attack_key)
    @user_board.cells[key].fire_upon
    @available_keys.delete(key)
    @attacked_keys << key
  end

  # def split_key(key)
  #   key.split
  # end

  def generate_smart_attack_key
    last_key = @attacked_keys.last

    if @attacked_keys.empty? || @user_board.cells[last_key].render == "X" || @user_board.cells[last_key].render == "M"
      generate_random_attack_key


    elsif @user_board.cells[last_key].render == "H"
      last_letter = last_key.split("")[0].ord
      last_number = last_key.split("")[1].to_i
      #binding.pry
      #moves up
      if last_letter > 65
        next_letter = (last_letter - 1).chr
        next_key = "#{next_letter}#{last_number}"
        #binding.pry
        if !@attacked_keys.include?(next_key)
          return next_key
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
