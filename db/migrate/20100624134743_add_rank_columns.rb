class AddRankColumns < ActiveRecord::Migration
  def self.up
    add_column :torrents, :rank_s, :float, {:default => 0.0}
    add_column :torrents, :rank_l, :float, {:default => 0.0}
    add_column :torrents, :rank_agg, :float, {:default => 0.0}

    add_index :torrents, :rank_s
    add_index :torrents, :rank_l
    add_index :torrents, :rank_agg
  end

  def self.down
    remove_column :torrents, :rank_s, :rank_l, :rank_agg

    remove_index :torrents, :column => :rank_s
    remove_index :torrents, :column => :rank_l
    remove_index :torrents, :column => :rank_agg
  end
end
