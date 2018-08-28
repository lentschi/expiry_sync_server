class CreateApplicationSettings < ActiveRecord::Migration
  def change
    create_table :application_settings do |t|
      t.string :setting_key, null: false, unique: true
      t.string :setting_value, null: false
    end
  end
end
