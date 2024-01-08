class BoardsController < ApplicationController
  before_action :set_board, only: %i[ show ]

  # GET /boards or /boards.json
  def index
    @boards = Board.order(created_at: :desc)
    @boards = @boards.first(10) unless params[:show_all]
  end

  # GET /boards/1 or /boards/1.json
  def show
  end

  # GET /boards/new
  def new
    @board = Board.new
  end

  # POST /boards or /boards.json
  def create
    @board = Board.new(board_params)

    respond_to do |format|
      if @board.save
        format.html { redirect_to board_url(@board), notice: "Board was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_board
      @board = Board.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def board_params
      params.require(:board).permit(:name, :email, :width, :height, :mine_count)
    end
end
