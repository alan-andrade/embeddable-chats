# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130908061112) do

  create_table "authorizations", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chats", force: true do |t|
    t.integer "owner_id"
  end

  create_table "messages", force: true do |t|
    t.integer  "room_id"
    t.integer  "sender_id"
    t.string   "body",       default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["room_id"], name: "index_messages_on_room_id"
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id"

  create_table "room_participations", force: true do |t|
    t.integer "user_id"
    t.integer "room_id"
  end

  add_index "room_participations", ["room_id"], name: "index_room_participations_on_room_id"
  add_index "room_participations", ["user_id"], name: "index_room_participations_on_user_id"

  create_table "rooms", force: true do |t|
    t.string  "subject"
    t.integer "chat_id"
    t.boolean "is_open", default: true
  end

  add_index "rooms", ["chat_id"], name: "index_rooms_on_chat_id"

  create_table "users", force: true do |t|
    t.string "email"
  end

end
