class CreateTorrents < ActiveRecord::Migration
    def self.up
        create_table :torrents, :options => 'engine = "MyISAM"' do |t|
            t.string :title, :limit => 100, :null => false
            t.string :tags, :limit => 80, :null => false
            t.integer :size, :null => false

            t.timestamps
        end

        execute "ALTER TABLE " + :torrents.to_s + " ADD tHash binary(20) NOT NULL"

        add_index :torrents, [:tHash, :id], { :unique => true }
        #add_index :torrents, [:title, :tags]
    end

    def self.down
        drop_table :torrents
    end
end
