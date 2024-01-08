class Tile < ApplicationRecord
  belongs_to :board
  validates :x, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :y, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :in_board_bounds

  private
  def in_board_bounds
    if(board && x && y)
      errors.add :x, ("must be less than board width") unless x < board.width
      errors.add :y, ("must be less than board height") unless y < board.height
    end
  end
end
