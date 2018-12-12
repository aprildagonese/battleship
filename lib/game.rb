require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/valid_placement'
require './lib/turn'
require './lib/computer_brain'
require 'pry'

class Game

  def initialize
  end

  def game_start
    puts "Welcome to BATTLESHIP"
    get_start_message_input
    set_up_game
  end

  def set_up_game
    system('clear')
    puts "The sides of our boards can be anywhere from 4 cells to 26 cells wide. Please enter a number between 4 and 26 to tell me how big our boards should be."
    board_size = get_board_size
    @user_board = Board.new(board_size)
    @computer_board = Board.new(board_size)

    @computer_player = ComputerBrain.new(@user_board, @computer_board)
    @computer_player.cpu_place_ships(@computer_board.ships)

    set_up_board
    system('clear')
    initial_board_display
    puts "Ok, game on!"

    until (all_ships_sunk?(@user_board) || all_ships_sunk?(@computer_board))
      Turn.new(@user_board, @computer_board, @computer_player).take_turn
    end

    end_game
    puts "Would you like to play again?"
    get_start_message_input
    Game.new.set_up_game
  end

  def get_start_message_input
    puts "Enter p to play or q to quit. You can also enter 'exit' at any time during the game to quit."
    user_input = gets.chomp.to_s.strip.upcase
    if user_input == "EXIT"
      abort('Goodbye.')
    elsif user_input == "Q"
      abort('Goodbye.')
    elsif user_input == "P"
      return
    else
      puts "Sorry, what was your choice?"
      get_start_message_input
    end
  end

  def get_board_size
    board_size = gets.chomp
    if board_size.to_s.strip.upcase == "EXIT"
      abort("Goodbye.")
    elsif board_size.to_i < 4 || board_size.to_i > 26
      puts "Sorry, it needs to be a number between 4 and 26. Please try again."
      get_board_size
    else
      system('clear')
      puts "Ok, we'll play on #{board_size}x#{board_size} boards."
      return board_size.to_i
    end
  end

  def set_up_board
    ships_message
    @user_board.ships.each do |ship|
      validate_placement(ship)
    end
  end

  def ships_message
    puts "Now you need to place your ships. Here is your board:"
    puts @user_board.render(true)
    puts "You have the following ships to play with:"
    ships = @user_board.ships
    ships.each do |ship|
      puts "#{ship.name}, #{ship.length} cells long"
    end
    puts "-------------------------"
    return ships
  end

  def validate_placement(ship)
    puts "Please choose #{ship.length} cells where you would like to place your #{ship.name}. For example, you can type 'A1, A2, etc.' separated by commas:"
    user_input = gets.chomp
    user_coords = user_input.upcase.gsub(/\s+/, "").split(",")
    if user_input.to_s.strip.upcase == "EXIT"
      abort("Goodbye.")
    elsif @user_board.valid_placement?(ship, user_coords)
      user_coords.each do |coord|
        @user_board.cells[coord].place_ship(ship)
      end
      system('clear')
      puts "Great! Your #{ship.name} is now on cells #{user_coords}."
      puts @user_board.render(true)
    else
      puts "Sorry, those cells don't work. Try again."
      validate_placement(ship)
    end
  end

  def initial_board_display #this is repeated in Turn, but turn and game don't know about each other
    puts "*** Here's your current board *** \n"
    puts @user_board.render(true)
    puts "------------------------------------"
    puts "*** Here's my current board *** \n"
    puts @computer_board.render
    puts "------------------------------------"
  end

  def all_ships_sunk?(board)
    board.ships.all? do |ship|
      ship.sunk?
    end
  end

  def end_game
    system('clear')
    puts "*** Here's your final board *** \n"
    puts @user_board.render(true)
    puts "------------------------------------"
    puts "*** Here's my final board *** \n"
    puts @computer_board.render
    puts "------------------------------------"
    puts " "
    if (all_ships_sunk?(@user_board) && all_ships_sunk?(@computer_board))
      puts "We got a tie!"
    elsif all_ships_sunk?(@user_board)
      puts "I sunk all your ships! I win!"
    elsif all_ships_sunk?(@computer_board)
      puts "You sunk all my ships! You win!"
    end
  end

end
