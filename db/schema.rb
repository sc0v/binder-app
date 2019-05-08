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

ActiveRecord::Schema.define(version: 20190506153740) do

  create_table "certification_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "active",                 default: true
  end

  create_table "certifications", force: :cascade do |t|
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "participant_id",        limit: 4
    t.integer  "certification_type_id", limit: 4
    t.boolean  "active",                          default: true
  end

  add_index "certifications", ["certification_type_id"], name: "index_certifications_on_certification_type_id", using: :btree
  add_index "certifications", ["participant_id"], name: "index_certifications_on_participant_id", using: :btree

  create_table "charge_types", force: :cascade do |t|
    t.string   "name",                          limit: 255
    t.boolean  "requires_booth_chair_approval"
    t.decimal  "default_amount",                              precision: 8, scale: 2
    t.text     "description",                   limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                                                              default: true
  end

  create_table "charges", force: :cascade do |t|
    t.integer  "organization_id",          limit: 4
    t.integer  "charge_type_id",           limit: 4
    t.decimal  "amount",                                 precision: 8, scale: 2
    t.text     "description",              limit: 65535
    t.integer  "issuing_participant_id",   limit: 4
    t.integer  "receiving_participant_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "charged_at"
    t.boolean  "is_approved"
    t.integer  "creating_participant_id",  limit: 4
    t.boolean  "active",                                                         default: true
  end

  add_index "charges", ["organization_id"], name: "index_charges_on_organization_id", using: :btree

  create_table "checkouts", force: :cascade do |t|
    t.integer  "tool_id",         limit: 4
    t.datetime "checked_out_at"
    t.datetime "checked_in_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "participant_id",  limit: 4
    t.integer  "organization_id", limit: 4
    t.boolean  "active",                    default: true
  end

  add_index "checkouts", ["tool_id"], name: "index_checkouts_on_tool_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0,    null: false
    t.integer  "attempts",   limit: 4,     default: 0,    null: false
    t.text     "handler",    limit: 65535,                null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                   default: true
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "event_types", force: :cascade do |t|
    t.boolean "display"
    t.string  "name",    limit: 255
    t.boolean "active",              default: true
  end

  create_table "events", force: :cascade do |t|
    t.boolean  "is_done"
    t.integer  "event_type_id",  limit: 4
    t.datetime "created_at"
    t.text     "description",    limit: 65535
    t.datetime "updated_at"
    t.integer  "participant_id", limit: 4
    t.boolean  "active",                       default: true
  end

  create_table "faqs", force: :cascade do |t|
    t.text     "question",   limit: 65535
    t.text     "answer",     limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                   default: true
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "organization_id",   limit: 4
    t.integer  "participant_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_booth_chair"
    t.string   "title",             limit: 255
    t.integer  "booth_chair_order", limit: 4
    t.boolean  "active",                        default: true
  end

  add_index "memberships", ["organization_id"], name: "index_memberships_on_organization_id", using: :btree
  add_index "memberships", ["participant_id"], name: "index_memberships_on_participant_id", using: :btree

  create_table "organization_aliases", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "organization_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                      default: true
  end

  add_index "organization_aliases", ["name"], name: "index_organization_aliases_on_name", using: :btree
  add_index "organization_aliases", ["organization_id"], name: "index_organization_aliases_on_organization_id", using: :btree

  create_table "organization_categories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_building"
    t.boolean  "active",                  default: true
  end

  create_table "organization_status_types", force: :cascade do |t|
    t.string  "name",     limit: 255
    t.boolean "display"
    t.boolean "active",               default: true
    t.string  "category", limit: 255
  end

  create_table "organization_statuses", force: :cascade do |t|
    t.integer  "organization_status_type_id", limit: 4
    t.integer  "organization_id",             limit: 4
    t.integer  "participant_id",              limit: 4
    t.string   "description",                 limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                                  default: true
  end

  add_index "organization_statuses", ["organization_id"], name: "index_organization_statuses_on_organization_id", using: :btree

  create_table "organization_timeline_entries", force: :cascade do |t|
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer  "organization_id", limit: 4
    t.text     "description",     limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "entry_type",      limit: 4
    t.boolean  "active",                        default: true
  end

  add_index "organization_timeline_entries", ["organization_id"], name: "index_organization_timeline_entries_on_organization_id", using: :btree

  create_table "organization_timeline_entry_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                 default: true
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name",                     limit: 255
    t.integer  "organization_category_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_name",               limit: 255
    t.boolean  "active",                               default: true
  end

  add_index "organizations", ["organization_category_id"], name: "index_organizations_on_organization_category_id", using: :btree

  create_table "participants", force: :cascade do |t|
    t.string   "andrewid",                  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_signed_waiver"
    t.string   "phone_number",              limit: 255
    t.boolean  "has_signed_hardhat_waiver"
    t.integer  "user_id",                   limit: 4
    t.string   "cached_name",               limit: 255
    t.string   "cached_surname",            limit: 255
    t.string   "cached_email",              limit: 255
    t.string   "cached_department",         limit: 255
    t.string   "cached_student_class",      limit: 255
    t.datetime "cache_updated"
    t.datetime "waiver_start"
    t.boolean  "active",                                default: true
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "resource_id",   limit: 4
    t.string   "resource_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                    default: true
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "shift_participants", force: :cascade do |t|
    t.integer  "shift_id",       limit: 4
    t.integer  "participant_id", limit: 4
    t.datetime "clocked_in_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                   default: true
  end

  add_index "shift_participants", ["participant_id"], name: "index_shift_participants_on_participant_id", using: :btree
  add_index "shift_participants", ["shift_id"], name: "index_shift_participants_on_shift_id", using: :btree

  create_table "shift_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_name", limit: 255
    t.boolean  "active",                 default: true
  end

  create_table "shifts", force: :cascade do |t|
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer  "required_number_of_participants", limit: 4
    t.integer  "organization_id",                 limit: 4
    t.integer  "shift_type_id",                   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description",                     limit: 255
    t.boolean  "active",                                      default: true
  end

  add_index "shifts", ["organization_id"], name: "index_shifts_on_organization_id", using: :btree

  create_table "store_items", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.decimal  "price",                  precision: 8, scale: 2
    t.integer  "quantity",   limit: 4
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.boolean  "active",                                         default: true
  end

  create_table "store_purchases", force: :cascade do |t|
    t.integer  "charge_id",          limit: 4
    t.integer  "store_item_id",      limit: 4
    t.decimal  "price_at_purchase",            precision: 8, scale: 2
    t.integer  "quantity_purchased", limit: 4
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
    t.boolean  "active",                                               default: true
  end

  add_index "store_purchases", ["charge_id"], name: "index_store_purchases_on_charge_id", using: :btree
  add_index "store_purchases", ["store_item_id"], name: "index_store_purchases_on_store_item_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.datetime "due_at"
    t.integer  "completed_by_id", limit: 4
    t.string   "name",            limit: 255
    t.text     "description",     limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_completed"
    t.boolean  "active",                        default: true
  end

  create_table "tool_type_certifications", force: :cascade do |t|
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "tool_type_id",          limit: 4
    t.integer  "certification_type_id", limit: 4
    t.boolean  "active",                          default: true
  end

  add_index "tool_type_certifications", ["certification_type_id"], name: "index_tool_type_certifications_on_certification_type_id", using: :btree
  add_index "tool_type_certifications", ["tool_type_id"], name: "index_tool_type_certifications_on_tool_type_id", using: :btree

  create_table "tool_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                 default: true
  end

  create_table "tools", force: :cascade do |t|
    t.integer  "barcode",      limit: 4
    t.text     "description",  limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tool_type_id", limit: 4
    t.boolean  "active",                     default: true
  end

  add_index "tools", ["barcode"], name: "index_tools_on_barcode", using: :btree
  add_index "tools", ["tool_type_id"], name: "index_tools_on_tool_type_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",   null: false
    t.string   "encrypted_password",     limit: 255, default: "",   null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   limit: 255
    t.boolean  "active",                             default: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id", limit: 4
    t.integer "role_id", limit: 4
    t.boolean "active",            default: true
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  add_foreign_key "certifications", "certification_types"
  add_foreign_key "certifications", "participants"
  add_foreign_key "store_purchases", "charges"
  add_foreign_key "store_purchases", "store_items"
  add_foreign_key "tool_type_certifications", "certification_types"
  add_foreign_key "tool_type_certifications", "tool_types"
  add_foreign_key "tools", "tool_types"
end
