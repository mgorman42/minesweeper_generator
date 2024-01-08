class CreateTiles < ActiveRecord::Migration[7.1]
  def change
    create_table :tiles do |t|
      t.references :board
      t.integer :x
      t.integer :y

      t.boolean :is_mine

      t.timestamps
    end
  end
end
