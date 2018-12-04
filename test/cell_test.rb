require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'

class CellTest < Minitest::Test

  def test_cell_exists
    cell = Cell.new("B4")
    assert_instance_of Cell, cell
  end

  def test_cell_coordinate
    cell = Cell.new("B4")
    assert_equal "B4", cell.coordinate
  end

  def test_cell_ship_initial
    cell = Cell.new("B4")
    assert_equal nil, cell.ship
  end

  def test_cell_empty
    cell = Cell.new("B4")
    assert_equal true, cell.empty?
  end

  def test_place_ship
    cell = Cell.new("B4")
    cruiser = Ship.new("Cruiser", 3)
    cell.place_ship(cruiser)
    assert_equal cruiser, cell.ship
    assert_equal false, cell.empty?
  end
end
