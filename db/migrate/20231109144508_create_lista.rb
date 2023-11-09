class CreateLista < ActiveRecord::Migration[7.1]
  def change
    create_table :lista do |t|
      t.integer :pelicula
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
