class AddReplacementDetailsToAlternateServer < ActiveRecord::Migration
  def change
    add_column :alternate_servers, :replacement_url, :string

    reversible do |dir|
      dir.up do
        AlternateServer.add_translation_fields! replacement_explanation: :text
      end

      dir.down do
        remove_column :alternate_server_translations, :replacement_explanation
      end
    end
  end
end
