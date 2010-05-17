# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100409133051) do

  create_table "details", :force => true do |t|
    t.integer  "torrent_id", :null => false
    t.integer  "seed",       :null => false
    t.integer  "leech",      :null => false
    t.datetime "created_at"
  end

  add_index "details", ["created_at"], :name => "index_details_on_created_at"
  add_index "details", ["torrent_id"], :name => "index_details_on_torrent_id"

  create_table "torrents", :force => true do |t|
    t.string   "title",      :limit => 100, :null => false
    t.string   "tags",       :limit => 80,  :null => false
    t.integer  "size",                      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.binary   "tHash",      :null => false
  end

  add_index "torrents", ["tHash", "id"], :name => "index_torrents_on_tHash_and_id", :unique => true
  #add_index "torrents", ["title", "tags"], :name => "index_torrents_on_title_and_tags"

end
