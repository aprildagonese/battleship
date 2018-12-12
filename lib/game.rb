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
    puts "Would you like to (p)lay again or (q)uit?"
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

    ships = default_or_custom_ships
    @user_board.ships = ships
    @computer_board.ships = ships

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

  def default_or_custom_ships
    puts "Would you like to make your own ships? (Y/N)"
    user_input = gets.chomp.to_s.upcase
    if user_input == "Y"
      return make_custom_ships

    elsif user_input == "N"
      ships = get_default_ships
      ships.each do |ship|
        puts "#{ship.name}, #{ship.length} cells long"
      end
      return ships
    else
      puts "Invalid selection. Try again"
      default_or_custom_ships
    end
  end

  def make_custom_ships
    system('clear')
    puts @user_board.render(true)
    puts "\n"
    max_total = (@user_board.width * @user_board.width) / 3
    puts "You have chosen to make custom ships. Each ship will need a name, followed
    by a length (e.g. Destroyer, 3). You can only make straight ships. Also,
    because ships need room to move, your combined length of all ships cannot
    exceed #{max_total}."

    puts "\n"
    ship_count = 1
    ship_total = get_valid_custom_ship_number(max_total)
    length_total = 0
    custom_ships = []
    until ship_count > ship_total
      name = get_custom_ship_name(ship_count, ship_total)
      length = get_valid_ship_length(name, ship_count, max_total, length_total, ship_total)
      ship = Ship.new(name, length)
      custom_ships << ship
      ship_count += 1
      length_total += length
    end
    return custom_ships
  end

  def get_valid_custom_ship_number(max_total)
    puts "Please enter the number of ships you would like to make:"
    user_input = Integer(gets) rescue false
    if user_input == false
      puts "Invalid entry. Number of ships must be a number greater than 2 and
      less than or equal to #{max_total / 2}."
      get_valid_custom_ship_number(max_total)
    elsif user_input < 2 || user_input > (max_total / 2)
      puts "Invalid entry. Number of ships must be greater than 2 and less than
      or equal to #{max_total / 2}."
      get_valid_custom_ship_number (max_total)
    else
      return user_input
    end
  end

  def get_custom_ship_name(ship_count, ship_total)
    puts "Please enter a name for ship #{ship_count} out of #{ship_total}."
    gets.chomp
  end

  def get_valid_ship_length(name, ship_count, max_total, length_total, ship_total)
    puts "Please enter a length for #{name}. (#{ship_total - ship_count} more ships remaining)"
    user_input = Integer(gets) rescue false
    if user_input == false
      puts "Invalid entry. Ship length must be a number."
      get_valid_ship_length(name, ship_count, max_total, length_total, ship_total)
    elsif user_input < 2 || user_input > @user_board.width
      puts "Invalid entry. Ship length must be at least 2 and no more than #{@user_board.width}."
      get_valid_ship_length(name, ship_count, max_total, length_total, ship_total)
    else
      length = user_input
      remaining_length = max_total - length_total
      saving_length = (ship_total - ship_count) * 2
      if length > remaining_length - saving_length
        puts "Invalid length. Will not leave enough spots for your remaining ships.
        Please re-enter a shorter length for ship #{ship_count} out of #{ship_total}."
        get_valid_ship_length(name, ship_count, max_total, length_total, ship_total)
      else
        return length
      end
    end
  end

  def get_default_ships
    classic_ships = [["Destroyer", 2], ["Submarine", 3], ["Cruiser", 3],
                    ["Battleship", 4], ["Carrier", 5], ["Cruiser", 3],
                    ["Battleship", 4], ["Battleship", 4], ["Carrier", 5],
                    ["Carrier", 5], ["Iowa-class", 7], ["Iowa-class", 7]]
    if @user_board.width < 5
      ship_count = 2
    elsif @user_board.width < 8
      ship_count = 4
    elsif @user_board.width < 11
      ship_count = 5
    elsif @user_board.width < 14
      ship_count = 7
    elsif @user_board.width < 17
      ship_count = 9
    elsif @user_board.width < 19
      ship_count = 10
    elsif @user_board.width < 22
      ship_count = 11
    elsif @user_board.width < 27
      ship_count = 12
    end

    default_ships = []
    counter = 0
    until default_ships.count == ship_count
      default_ships << Ship.new(classic_ships[counter][0], classic_ships[counter][1])
      counter += 1
    end
    return default_ships
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
