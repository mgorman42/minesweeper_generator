class AddBoardIndexToTiles < ActiveRecord::Migration[7.1]
  def change
    add_column :tiles, :board_index,:integer
    add_index :tiles, [:board_id, :board_index]
  end
end
