class CreateAllowedPostcodes < ActiveRecord::Migration[6.1]
  def change
    create_table :allowed_postcodes do |t|
      t.string :postcode

      t.timestamps
    end
    add_index :allowed_postcodes, :postcode
  end
end
