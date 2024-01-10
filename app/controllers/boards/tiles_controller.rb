class Boards::TilesController < ApplicationController
  MAX_TILES_PER_PAGE = 1000

  def index
    @board = Board.find(params[:board_id])
    @page = params[:page].to_i || 0
    @page_count = @board.height / row_count_per_page
    page_row_start = row_count_per_page = [MAX_TILES_PER_PAGE / @board.width , @board.height].min
    @page*row_count_per_page
    page_row_stop = page_row_start + row_count_per_page
    @tiles = @board.as_2d_array(page_row_start...page_row_stop)
  end
end
