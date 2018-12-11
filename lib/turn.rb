class Turn
  attr_accessor :user_board, :computer_board

  def initialize(user_board, computer_board, computer_brain)
    @user_board = user_board
    @computer_board = computer_board
    @computer_brain = computer_brain
  end



#player gives us a coord, we find cell, we fire upon it
  def display_user_board
    @user_board.render(true)
  end

  def display_computer_board
    @computer_board.render
  end

  def player_attacks(get_coords)
    # p "Please enter coordinates:"
    #get_coords = gets.chomp().to_s
    if !@computer_board.valid_coordinate?(get_coords)
      p "Attack coordinate invalid. Please try again!"
      player_attacks(gets.chomp().to_s)
    elsif @computer_board.cells[get_coords].fired_upon?
      p "You've already attacked this cell! Please choose again."
      player_attacks(gets.chomp().to_s)
    else @computer_board.cells[get_coords].fire_upon
    end
  end

  def get_coords
    p "Please enter coordinates:"
    gets.chomp().to_s
  end

end
