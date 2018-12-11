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

  def set_up_game
    puts "Welcome to BATTLESHIP"
    get_start_message_input

    puts "The sides of our boards can be anywhere from 4 cells to 26 cells wide. Please enter a number between 4 and 26 to tell me how big our boards should be."
    board_size = get_board_size
    @user_board = Board.new(board_size)
    @computer_board = Board.new(board_size)

    @computer_player = ComputerBrain.new(@user_board, @computer_board)
    @computer_player.cpu_place_ships(@computer_board.get_ships)

    until #UNTIL USER BOARD SHIPS OR COMP BOARD SHIPS ARE ALL SUNK
      Turn.new(@user_board, @computer_board, @computer_player).take_turn
    end
  end

  def get_start_message_input
    puts "Enter p to play or q to quit:"
    user_input = gets.chomp.to_s
    if user_input == "q"
      abort('Goodbye.')
    elsif user_input == "p"
      return
    else
      puts "Sorry, what was your choice?"
      get_start_message_input
    end
  end

  def get_board_size
    board_size = gets.chomp.to_i
    if board_size < 4 || board_size > 26
      puts "Sorry, it needs to be a number between 4 and 26. Please try again."
      get_board_size
    else
      puts "Ok, we'll play on #{board_size}x#{board_size} boards."
      return board_size
    end
  end

  def set_up_board(board)
    generate_ships(board).each do |ship|
      validate_placement(ship)
    end
  end

  def ships_message(board) APRIL WORK ON THIS
    puts "Now you need to place your ships. Here is your board:"
    puts board.render(true)
    puts "You have the following ships to play with:"
    ships = board.ships
    ships = [@cruiser = Ship.new("Cruiser", 3), @submarine = Ship.new("Submarine", 2)]
    ships.each do |ship|
      puts "#{ship.name}, #{ship.length} cells long"
    end
    return ships
  end

  def validate_placement(ship)
    puts "Please choose #{ship.length} cells where you would like to place your #{ship.name}. For example, you can type 'A1, A2, etc.' separated by commas:"
    user_coords = gets.chomp.gsub(/\s+/, "").split(",")
    if @user_board.valid_placement?(ship, user_coords)
      user_coords.each do |coord|
        @user_board.cells[coord].place_ship(ship)
      end
      puts "Great! Your #{ship.name} is now on cells #{user_coords}."
    else
      puts "Sorry, those cells don't work. Try again."
      validate_placement(ship)
    end
  end

#Turn methods
#End game

end

game = Game.new
game.set_up_game
