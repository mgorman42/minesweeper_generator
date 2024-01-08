class IndexTilesByBoardIdYX < ActiveRecord::Migration[7.1]
  def change
    add_index :tiles, [:board_id, :y, :x] 
  end
end
