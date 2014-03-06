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

ActiveRecord::Schema.define(version: 20140306165608) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "dsars_dosr_configs", force: true do |t|
    t.integer  "environment_id"
    t.integer  "dosr_line_number"
    t.string   "name"
    t.integer  "lines",            default: [],   array: true
    t.boolean  "enabled",          default: true
    t.string   "format"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dsars_dosr_configs", ["environment_id"], name: "index_dsars_dosr_configs_on_environment_id", using: :btree
  add_index "dsars_dosr_configs", ["lines"], name: "index_dsars_dosr_configs_on_lines", using: :gin

  create_table "dsars_line_descriptions", force: true do |t|
    t.string   "report_type"
    t.integer  "report_version"
    t.integer  "line_number"
    t.string   "name"
    t.text     "description"
    t.boolean  "has_period",     default: true
    t.boolean  "has_total",      default: true
    t.string   "format"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dsars_report_ddas", force: true do |t|
    t.integer  "report_id"
    t.integer  "sfd_destroyed"
    t.integer  "mh_destroyed"
    t.integer  "apt_destroyed"
    t.integer  "sfd_major"
    t.integer  "mh_major"
    t.integer  "apt_major"
    t.integer  "sfd_minor"
    t.integer  "mh_minor"
    t.integer  "apt_minor"
    t.integer  "sfd_affected"
    t.integer  "mh_affected"
    t.integer  "apt_affected"
    t.integer  "sfd_inaccessible"
    t.integer  "mh_inaccessible"
    t.integer  "apt_inaccessible"
    t.integer  "completion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dsars_report_lines", force: true do |t|
    t.integer "report_id"
    t.integer "line_number"
    t.integer "period"
    t.integer "total"
  end

  add_index "dsars_report_lines", ["report_id"], name: "idx_report_lines_report_id", using: :btree

  create_table "dsars_reports", force: true do |t|
    t.string   "report_type"
    t.integer  "report_version"
    t.string   "dro_number"
    t.string   "incident_number"
    t.string   "incident_name"
    t.integer  "report_number"
    t.date     "cob_date"
    t.string   "unit_name"
    t.string   "unit_id"
    t.string   "county_name"
    t.string   "county_id"
    t.string   "scope"
    t.integer  "dsars_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dsars_reports", ["report_type", "report_number"], name: "idx_reports_type_number", using: :btree

  create_table "environments", force: true do |t|
    t.boolean  "enabled"
    t.date     "active_start_date"
    t.date     "active_end_date"
    t.string   "slug",                  null: false
    t.string   "name"
    t.string   "short_name"
    t.string   "cas_incident_number"
    t.string   "dsars_incident_number"
    t.string   "dr_number"
    t.string   "arcdata_incident_id"
    t.string   "time_zone_raw"
    t.hstore   "config"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "iap_plan_attachments", force: true do |t|
    t.integer  "plan_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "title"
    t.string   "audience"
    t.string   "attachment_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "iap_plan_attachments", ["plan_id"], name: "index_iap_plan_attachments_on_plan_id", using: :btree

  create_table "iap_plans", force: true do |t|
    t.integer  "environment_id"
    t.integer  "number"
    t.datetime "period_start"
    t.datetime "period_end"
    t.string   "status"
    t.string   "approver_name"
    t.string   "approver_title"
    t.datetime "approved_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "iap_plans", ["environment_id"], name: "index_iap_plans_on_environment_id", using: :btree

  create_table "iap_subscriptions", force: true do |t|
    t.integer  "environment_id"
    t.integer  "user_id"
    t.string   "name"
    t.string   "email"
    t.string   "audience"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "iap_subscriptions", ["environment_id"], name: "index_iap_subscriptions_on_environment_id", using: :btree
  add_index "iap_subscriptions", ["user_id"], name: "index_iap_subscriptions_on_user_id", using: :btree

  create_table "region_environments", force: true do |t|
    t.integer  "region_id"
    t.integer  "environment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "region_environments", ["environment_id"], name: "index_region_environments_on_environment_id", using: :btree
  add_index "region_environments", ["region_id"], name: "index_region_environments_on_region_id", using: :btree

  create_table "regions", force: true do |t|
    t.string   "name"
    t.string   "short_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sitreps_prompts", force: true do |t|
    t.boolean  "required"
    t.string   "title"
    t.integer  "sitrep_config_id"
    t.integer  "ordinal"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sitreps_prompts", ["sitrep_config_id"], name: "index_sitreps_prompts_on_sitrep_config_id", using: :btree

  create_table "sitreps_responses", force: true do |t|
    t.integer  "sitrep_id"
    t.string   "title"
    t.text     "response"
    t.integer  "ordinal"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sitreps_responses", ["sitrep_id"], name: "index_sitreps_responses_on_sitrep_id", using: :btree

  create_table "sitreps_sitrep_configs", force: true do |t|
    t.integer  "environment_id"
    t.boolean  "allow_unauthenticated_submit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sitreps_sitrep_configs", ["environment_id"], name: "index_sitreps_sitrep_configs_on_environment_id", using: :btree

  create_table "sitreps_sitreps", force: true do |t|
    t.integer  "environment_id"
    t.date     "date"
    t.hstore   "data"
    t.integer  "creator_id"
    t.string   "activity"
    t.string   "territory"
    t.string   "submitter_name"
    t.string   "submitter_title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sitreps_sitreps", ["creator_id"], name: "index_sitreps_sitreps_on_creator_id", using: :btree
  add_index "sitreps_sitreps", ["environment_id"], name: "index_sitreps_sitreps_on_environment_id", using: :btree

  create_table "territories", force: true do |t|
    t.integer  "environment_id"
    t.string   "name"
    t.string   "description"
    t.integer  "ordinal"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "territories", ["environment_id"], name: "index_territories_on_environment_id", using: :btree

  create_table "territory_scopes", force: true do |t|
    t.integer  "territory_id"
    t.string   "scope_type"
    t.string   "unit_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "territory_scopes", ["territory_id"], name: "index_territory_scopes_on_territory_id", using: :btree

  create_table "user_environments", force: true do |t|
    t.integer  "user_id"
    t.integer  "environment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_environments", ["environment_id"], name: "index_user_environments_on_environment_id", using: :btree
  add_index "user_environments", ["user_id"], name: "index_user_environments_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.integer  "chapter_id"
    t.boolean  "vc_is_active"
    t.integer  "region_id"
  end

end
