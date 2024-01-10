class Boards::TilesController < ApplicationController
  MAX_TILES_PER_PAGE = 1000

  def index
    @board = Board.find(params[:board_id])
    @page = params[:page].to_i || 0
    @page_count = @board.height / row_count_per_page
    @tiles = @board.as_2d_array(page_row_start...page_row_stop)
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  private
  def row_count_per_page
    @_row_count_per_page ||= [MAX_TILES_PER_PAGE / @board.width , @board.height].min
  end

  def page_row_start
    @_page_row_start ||= @page*row_count_per_page
  end

  def page_row_stop
    @_page_row_stop ||= page_row_start + row_count_per_page
  end
end
