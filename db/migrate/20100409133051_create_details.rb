class CreateDetails < ActiveRecord::Migration
    def self.up
        create_table :details do |t|
            t.integer :torrent_id, :null => false
            t.integer :seed, :null => false
            t.integer :leech, :null => false
            t.timestamp :created_at
        end

        add_index :details, :torrent_id
        add_index :details, :created_at
    end

    def self.down
        drop_table :details
    end
end
