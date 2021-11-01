class CreateAllowedLsoas < ActiveRecord::Migration[6.1]
  def change
    create_table :allowed_lsoas do |t|
      t.string :lsoa

      t.timestamps
    end
    add_index :allowed_lsoas, :lsoa
  end
end
