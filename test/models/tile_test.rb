require "test_helper"

class TileTest < ActiveSupport::TestCase
  context "associations" do
    should belong_to(:board)
  end

  context "validations" do
    should validate_presence_of(:x)
    should validate_presence_of(:y)
  end

  test "validates that x is GTE 0 and LT Board width" do
    board = FactoryBot.build(:board, width: 5, height: 2)
    assert FactoryBot.build(:tile, board: board, x: 0).valid?
    assert FactoryBot.build(:tile, board: board, x: 4).valid?
    assert_not FactoryBot.build(:tile, board: board, x: -1).valid?
    assert_not FactoryBot.build(:tile, board: board, x: 5).valid?
    assert_not FactoryBot.build(:tile, board: board, x: 6).valid?
  end

  test "validates that y is GTE 0 and LT Board width" do
    board = FactoryBot.build(:board, width: 2, height: 5)
    assert FactoryBot.build(:tile, board: board, y: 0).valid?
    assert FactoryBot.build(:tile, board: board, y: 4).valid?
    assert_not FactoryBot.build(:tile, board: board, y: -1).valid?
    assert_not FactoryBot.build(:tile, board: board, y: 5).valid?
    assert_not FactoryBot.build(:tile, board: board, y: 6).valid?
  end
end
