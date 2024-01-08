class IndexTilesByBoardIdXy < ActiveRecord::Migration[7.1]
  def change
    add_index :tiles, [:board_id, :x, :y]
  end
end
