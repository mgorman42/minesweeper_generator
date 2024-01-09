require "test_helper"

class BoardTest < ActiveSupport::TestCase
  context "associations" do
    should have_many(:tiles)
  end

  context "validations" do
    should validate_presence_of(:name)
    should validate_presence_of(:email)
    should allow_value("user@example.com").for(:email)
    should_not allow_value("not-an-email").for(:email)
    should validate_presence_of(:width)
    should validate_presence_of(:height)
    should validate_presence_of(:mine_count)
  end

  test "validates width is GT 0" do
    assert FactoryBot.build(:board).valid?
    assert_not FactoryBot.build(:board, width: 0).valid?
    assert_not FactoryBot.build(:board, width: -1).valid?
  end

  test "validates height is GT 0" do
    assert FactoryBot.build(:board).valid?
    assert_not FactoryBot.build(:board, height: 0).valid?
    assert_not FactoryBot.build(:board, height: -1).valid?
  end

  test "validates mine_count is GT 0 and LT count of tiles" do
    assert FactoryBot.build(:board).valid?
    assert_not FactoryBot.build(:board, mine_count: 0).valid?
    assert_not FactoryBot.build(:board, mine_count: -1).valid?
    assert FactoryBot.build(:board, width: 5, height: 5, mine_count: 24).valid?
    assert_not FactoryBot.build(:board, width: 5, height: 5, mine_count: 25).valid?
    assert_not FactoryBot.build(:board, width: 5, height: 5, mine_count: 26).valid?
  end

  test 'as_2d_array' do
    board = FactoryBot.create(:board, width: 5, height: 5)
    board.tiles.where("y < 2").update_all(is_mine: true)
    board.tiles.where("y >= 2").update_all(is_mine: false)
    expected = [
      Array.new(5, true),
      Array.new(5, true),
      Array.new(5, false),
      Array.new(5, false),
      Array.new(5, false),
    ]
    assert_equal expected, board.as_2d_array
  end

  test 'generate_board' do
    board = FactoryBot.build(:board, width: 5, height: 5, mine_count: 12)
    assert board.tiles.empty?
    board.save
    assert_equal 25, board.tiles.count
    assert_equal 12, board.tiles.where(is_mine: true).count
    assert_equal 13, board.tiles.where(is_mine: false).count
  end
end
