class Board < ApplicationRecord
  has_many :tiles
  validates :name, presence: true
  validates :email, presence: true, format: URI::MailTo::EMAIL_REGEXP
  validates :width, presence: true, numericality: { greater_than: 0 }
  validates :height, presence: true, numericality: { greater_than: 0 }
  validates :mine_count, presence: true, numericality: { greater_than: 0 }
  validate :mine_count_less_than_tile_count

  private
  def mine_count_less_than_tile_count
    if (mine_count && width && height)
      errors.add :mine_count, ("must be less than total tile count") unless mine_count < width * height
    end
  end
end
