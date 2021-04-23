class CreatePages < ActiveRecord::Migration[6.1]
  def change
    create_table :pages do |t|
      t.string :name
      t.json :metadata

      t.timestamps
    end
  end
end
