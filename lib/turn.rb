class Turn
  attr_accessor :user_board, :computer_board

  def initialize(user_board, computer_board, computer_brain)
    @user_board = user_board
    @computer_board = computer_board
    @computer_brain = computer_brain
  end

  def take_turn
    player_attacks
    @computer_brain.computer_attacks
    display_user_board
    display_computer_board
    player_outcome
    computer_outcome
    puts "\n"
  end

  def display_user_board
    puts "*** Here's your current board *** \n"
    puts @user_board.render(true)
    puts "------------------------------------"

  end

  def display_computer_board
    puts "*** Here's my current board *** \n"
    puts @computer_board.render
    puts "------------------------------------"
  end

  def player_attacks(attack_coords = get_coords)
    # attack_coords = get_coords
    if !@computer_board.valid_coordinate?(attack_coords)
      puts "Attack coordinate invalid. Please try again!"
      player_attacks
    elsif @computer_board.cells[attack_coords].fired_upon?
      puts "You've already attacked this cell! Please choose again."
      player_attacks
    else @computer_board.cells[attack_coords].fire_upon
      puts "Executing attack on #{attack_coords}."
      @computer_board.attacked_cells << attack_coords
      system('clear')
    end
  end

  def get_coords
    p "What coordinates would you like to attack? For example, you can enter A1:"
    user_input = gets.chomp
    user_coords = user_input.upcase.gsub(/\s+/, "")
    if user_input.to_s.strip.upcase == "EXIT"
      abort("Goodbye.")
    else
      return user_coords
    end
  end

  def player_outcome
    last_attack = @computer_board.cells[@computer_board.attacked_cells.last]
    if last_attack.render == "X"
      puts "You sunk my #{last_attack.ship.name}!"
    elsif last_attack.render == "H"
        puts "You got a hit!"
    elsif last_attack.render == "M"
      puts "You missed!"
    else
      puts "SOMETHING WENT WRONG HERE; CHECK PLAYER OUTCOME"
    end
  end

  def computer_outcome
    last_attack = @user_board.cells[@user_board.attacked_cells.last]
    if last_attack.render == "X"
      puts "The computer sunk your #{last_attack.ship.name}!"
    elsif last_attack.render == "H"
        puts "The computer got a hit!"
    elsif last_attack.render == "M"
      puts "The computer missed!"
    else
      puts "SOMETHING WENT WRONG HERE; CHECK COMPUTER OUTCOME"
    end
  end

end
