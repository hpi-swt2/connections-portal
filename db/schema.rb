# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_12_22_090231) do

  create_table "notes", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "current_status"
    t.string "username"
    t.string "firstname"
    t.string "lastname"
    t.string "place_of_residence"
    t.date "birthdate"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_contact_requests", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "contact_request_id"
    t.index ["contact_request_id"], name: "index_users_contact_requests_on_contact_request_id"
    t.index ["user_id"], name: "index_users_contact_requests_on_user_id"
  end

  create_table "users_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "contact_id"
    t.index ["contact_id"], name: "index_users_users_on_contact_id"
    t.index ["user_id"], name: "index_users_users_on_user_id"
  end

  add_foreign_key "notes", "users"
end
