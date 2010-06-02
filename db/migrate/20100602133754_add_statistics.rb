class AddStatistics < ActiveRecord::Migration
  def self.up
      #pridame statisticke stlpce seedov
      add_column :torrents, :average_s, :float
      add_column :torrents, :deviation_s, :float
      #leechov
      add_column :torrents, :average_l, :float
      add_column :torrents, :deviation_l, :float
  end

  def self.down
      remove_column :torrents, :average_s
      remove_column :torrents, :deviation_s

      remove_column :torrents, :average_l
      remove_column :torrents, :deviation_l
  end
end
