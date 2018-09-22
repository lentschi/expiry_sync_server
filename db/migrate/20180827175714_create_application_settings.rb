class CreateApplicationSettings < ActiveRecord::Migration[4.2]
  def change
    create_table :application_settings do |t|
      t.string :setting_key, null: false, unique: true
      t.string :setting_value, null: false
    end
  end
end
