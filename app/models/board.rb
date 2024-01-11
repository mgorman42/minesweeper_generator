require 'lfsr/fast'

class Board < ApplicationRecord
  has_many :tiles
  validates :name, presence: true
  validates :email, presence: true, format: URI::MailTo::EMAIL_REGEXP
  validates :width, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 1000 }
  validates :height, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 1000 }
  validates :mine_count, presence: true, numericality: { greater_than: 0 }
  validate :mine_count_less_than_tile_count
  after_save :generate_board

  def as_2d_array(y = nil)
    grid = []
    y_offset = y.try(:first) || y || 0
    selected_tiles = tiles
    selected_tiles = selected_tiles.where(y: y) if y
    selected_tiles.order(:y, :x).find_each do |tile|
      y_index = tile.y - y_offset
      grid[y_index] ||= []
      grid[y_index][tile.x] = tile.is_mine?
    end
    grid
  end

  private
  def mine_count_less_than_tile_count
    if (mine_count && width && height)
      errors.add :mine_count, ("must be less than total tile count") unless mine_count < tile_count
    end
  end

  def generate_board
    return false unless self.errors.empty?
    generate_tiles
    generate_mines
  end

  def generate_mines
    gen = LFSR.gen(tile_count - 1) # LFSR gen random number range is inclusive
    offset = rand(tile_count) # Rand random number range only includes min not max
    remaining_mines = mine_count
    mines_batch = []
    while remaining_mines > 0 do
      batch_size = [1000, remaining_mines].min
      batch_size.times do
        index = gen.next_i - offset
        index += tile_count if index < 0
        mines_batch << index
      end
      Tile.where(board_id: self.id, board_index: mines_batch).update_all(is_mine: true)
      mines_batch = []
      remaining_mines -= batch_size
    end
  end

  def generate_tiles
    i = 0
    tile_hashes = []
    height.times do |y|
      width.times do |x|
        tile_hashes << {
          board_id: self.id,
          y: y,
          x: x,
          board_index: i,
          is_mine: false
        }
        i += 1
        if (i % 1000 == 0)
          Tile.insert_all(tile_hashes)
          tile_hashes = []
        end
      end
    end
    Tile.insert_all(tile_hashes)
  end

  def tile_count
    return 0 unless height && width
    height * width
  end
end
