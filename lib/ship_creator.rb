require './lib/ship'

class ShipCreator

  def initialize(user_board)
    @user_board = user_board
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

end
