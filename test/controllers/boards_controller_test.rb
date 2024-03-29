require "test_helper"

class BoardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @board = FactoryBot.create(:board)
  end

  test "should get index" do
    get boards_url
    assert_response :success
  end

  test "should get new" do
    get new_board_url
    assert_response :success
  end

  test "should create board" do
    new_board = FactoryBot.build(:board)
    assert_difference("Board.count") do
      post boards_url, params: {
        board: {
          name: new_board.name,
          email: new_board.email,
          width: new_board.width,
          height: new_board.height,
          mine_count: new_board.mine_count
        }
      }
    end

    assert_redirected_to board_url(Board.last)
  end

  test "should show board" do
    get board_url(@board)
    assert_response :success
  end
end
