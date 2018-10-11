class AlterUsersChangeUsename < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.change :username, :binary, null: false, default: '', limit: 255
    end
  end
end
