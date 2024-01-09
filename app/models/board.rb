require 'lfsr/fast'

class Board < ApplicationRecord
  has_many :tiles
  validates :name, presence: true
  validates :email, presence: true, format: URI::MailTo::EMAIL_REGEXP
  validates :width, presence: true, numericality: { greater_than: 0 }
  validates :height, presence: true, numericality: { greater_than: 0 }
  validates :mine_count, presence: true, numericality: { greater_than: 0 }
  validate :mine_count_less_than_tile_count
  after_save :generate_board

  def as_2d_array
    grid = []
    tiles.order(:y, :x).find_each do |tile|
      grid[tile.y] ||= []
      grid[tile.y][tile.x] = tile.is_mine?
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
    mines = generate_mines_list
    generate_tiles(mines)
  end

  def generate_mines_list
    gen = LFSR.gen(tile_count - 1) # LFSR gen random number range is inclusive
    offset = rand(tile_count) # Rand random number range only includes min not max
    mine_count.times.map do
      index = gen.next_i - offset
      index += tile_count if index < 0
      index
    end
  end

  def generate_tiles(mines)
    ys = (0...height).to_a
    xs = (0...width).to_a
    tile_hashes = ys.product(xs).each_with_index.map do | (y, x), index |
      {
        board_id: self.id,
        y: y,
        x: x,
        is_mine: mines.include?(index)
      }
    end
    Tile.insert_all!(tile_hashes)
  end

  def tile_count
    return 0 unless height && width
    height * width
  end
end
