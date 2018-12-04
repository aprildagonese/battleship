require 'minitest/autorun'
require 'minitest/test'
require './lib/ship'
require './lib/cell'

class TestCell < Minitest::Test

  def test_it_exists
    cell = Cell.new("B4")
    assert_instance_of Cell, cell
  end

  def test_retrieve_coordinate
    cell = Cell.new("B4")
    assert_equal "B4", cell.cell
  end

  def test_empty_at_initialization
    cell = Cell.new("B4")
    assert_equal true, cell.empty?
  end

  def test_ship_in_cell
    cell = Cell.new("B4")
    cruiser = Ship.new("Cruiser", 3)
    cell.place_ship(cruiser)
    assert_equal cruiser, cell.ship
  end

  def test_cell_no_longer_empty
    cell = Cell.new("B4")
    cruiser = Ship.new("Cruiser", 3)
    cell.place_ship(cruiser)
    assert_equal false, cell.empty?
  end

  def test_not_fired_upon_at_initialize
    cell = Cell.new("B4")
    cruiser = Ship.new("Cruiser", 3)
    cell.place_ship(cruiser)
    assert_equal false, cell.fired_upon?
  end

  def test_fired_upon_after_hit
    cell = Cell.new("B4")
    cruiser = Ship.new("Cruiser", 3)
    cell.place_ship(cruiser)
    cell.fire_upon
    assert_equal true, cell.fired_upon?
  end


end
