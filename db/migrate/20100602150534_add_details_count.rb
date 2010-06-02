class AddDetailsCount < ActiveRecord::Migration
  def self.up
      add_column :torrents, :details_count, :integer, {:default => 1}
  end

  def self.down
      remove_column :torrents, :details_count
  end
end
