require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/valid_placement'
require './lib/turn'
require './lib/computer_brain'
require './lib/ship_creator'
require 'pry'

class Game

  def initialize
  end

  def game_start
    system('clear')
    puts "Welcome to BATTLESHIP"
    get_start_message_input
    set_up_game
  end

  def set_up_game
    system('clear')
    puts "Please enter the board size on which you wish to play. The sides of the boards can be anywhere from 4 cells to 26 cells."
    board_size = get_board_size
    @user_board = Board.new(board_size)
    @computer_board = Board.new(board_size)
    @computer_player = ComputerBrain.new(@user_board, @computer_board)

    set_up_board
    @computer_player.cpu_place_ships(@computer_board.ships)

    system('clear')
    initial_board_display
    puts "Ok, game on!"

    until (all_ships_sunk?(@user_board) || all_ships_sunk?(@computer_board))
      Turn.new(@user_board, @computer_board, @computer_player).take_turn
    end

    end_game
    get_start_message_input
    Game.new.set_up_game
  end

  def get_start_message_input
    puts "Would you like to (p)lay or (q)uit? You can also enter 'exit' at any time during the game to quit."
    user_input = gets.chomp.to_s.strip.upcase
    if user_input == "EXIT"
      abort('Coward.')
    elsif user_input == "Q"
      abort('Coward.')
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
      puts "Ok, the game shall have #{board_size}x#{board_size} boards."
      return board_size.to_i
    end
  end

  def set_up_board
    puts "You must first place your ships:"
    puts @user_board.render(true)
    puts "\n"


    game_ships = ShipCreator.new(@user_board)
    game_ships.default_or_custom_ships
    @user_board.ships = game_ships.user_ships
    @computer_board.ships = game_ships.cpu_ships

    system('clear')
    puts "Ok. The game shall be played with the following #{@user_board.ships.count} ships: "
    @user_board.ships.each do |ship|
      puts "#{ship.name} (#{ship.length})"
    end
    puts "\n"

    puts @user_board.render(true)
    puts "\n"
    @user_board.ships.each do |ship|
      validate_placement(ship)
    end
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
      puts "Great! Your #{ship.name} is now on cells #{user_coords}:"
      puts "\n"
      puts @user_board.render(true)
      puts "\n"
    else
      puts "Sorry, those cells don't work. Try again."
      validate_placement(ship)
    end
  end

  def initial_board_display #this is repeated in turn, but turn and game don't know about each other
    puts "*** Player current board *** \n"
    puts @user_board.render(true)
    puts "------------------------------------"
    puts "*** Computer current board *** \n"
    puts @computer_board.render
    puts "------------------------------------"
    puts "\n"
  end

  def all_ships_sunk?(board)
    board.ships.all? do |ship|
      ship.sunk?
    end
  end

  def end_game
    system('clear')
    puts "*** Player's final board *** \n"
    puts @user_board.render(true)
    puts "------------------------------------"
    puts "*** Computer's final board *** \n"
    puts @computer_board.render(true)
    puts "------------------------------------"
    puts " "
    if (all_ships_sunk?(@user_board) && all_ships_sunk?(@computer_board))
      puts "It's a tie! That will go well with your new suit."
    elsif all_ships_sunk?(@user_board)
      puts "The computer sunk all your ships! You're a loser!"
    elsif all_ships_sunk?(@computer_board)
      puts "You sunk all the computer's ships! You win!"
    end
  end

end
