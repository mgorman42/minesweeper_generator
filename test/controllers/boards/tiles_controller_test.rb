require "test_helper"

class BoardsControllerTest < ActionDispatch::IntegrationTest
  test "should return entire small board" do
    board = FactoryBot.create(:board, width: 5, height: 5, mine_count: 12)
    get board_tiles_url(board_id: board.id)
    assert_response :success
    assert body.include?("tiles-page-0")
    assert_not body.include?("tiles-page-1")
    assert_equal 25, body.scan("<td>").count
  end

  test "Should return 1 page of large board" do
    board = FactoryBot.create(:board, width: 100, height: 100, mine_count: 12)
    get board_tiles_url(board_id: board.id)
    assert_response :success
    assert body.include?("tiles-page-0")
    assert body.include?("tiles-page-1")
    assert_equal 1000, body.scan("<td>").count
  end
end
