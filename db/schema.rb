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

ActiveRecord::Schema.define(version: 20140724074534) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "affiliations", force: true do |t|
    t.boolean  "company"
    t.integer  "country_id"
    t.integer  "organization_id"
    t.integer  "department_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments", force: true do |t|
    t.string   "file"
    t.string   "folder"
    t.integer  "dataset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "filecreation"
    t.datetime "filechange"
    t.string   "fullfilename"
  end

  create_table "beaglebones", force: true do |t|
    t.string   "serialnumber"
    t.string   "internal_ip"
    t.datetime "last_seen"
    t.string   "external_ip"
    t.string   "version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "citations", force: true do |t|
    t.string   "doi"
    t.string   "fullcitation"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "relationtype"
  end

  create_table "commits", force: true do |t|
    t.integer  "dataset_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "country_organizations", force: true do |t|
    t.integer  "country_id"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "datasetgroup_datasets", force: true do |t|
    t.integer  "datasetgroup_id"
    t.integer  "dataset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "datasetgroups", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "datasets", force: true do |t|
    t.integer  "molecule_id"
    t.string   "title"
    t.text     "description"
    t.string   "method"
    t.text     "details"
    t.string   "version"
    t.integer  "preview_id"
    t.string   "uniqueid"
    t.integer  "method_rank"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.datetime "recorded_at"
    t.integer  "sample_id"
    t.string   "jdx_file"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "department_groups", force: true do |t|
    t.integer  "department_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "device_locations", force: true do |t|
    t.integer  "device_id"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "devices", force: true do |t|
    t.string   "name"
    t.string   "connectiontype"
    t.string   "portbaud"
    t.string   "portdetails"
    t.string   "portname"
    t.string   "porttype"
    t.integer  "devicetype_id"
    t.integer  "beaglebone_id"
    t.datetime "lastseen"
    t.string   "websockifygateway"
    t.string   "websockifygatewayport"
    t.string   "vnchost"
    t.string   "vncport"
    t.string   "token"
    t.string   "vncpassword"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vncrelay_id"
    t.string   "fwroot"
  end

  create_table "devicetypes", force: true do |t|
    t.string   "name"
    t.string   "displayname"
    t.string   "porttype"
    t.string   "portname"
    t.string   "portbaud"
    t.string   "portdetails"
    t.boolean  "showcase",       default: false
    t.integer  "deviceclass_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "portdatabits",   default: 8
    t.string   "portparity",     default: "none"
    t.integer  "portstopbits",   default: 1
    t.string   "portlinebreak",  default: "0A"
    t.string   "portprefix",     default: ""
    t.string   "portsuffix",     default: ""
  end

  create_table "folder_watchers", force: true do |t|
    t.integer  "device_id"
    t.string   "pattern"
    t.string   "rootfolder"
    t.string   "scanfilter"
    t.string   "serialnumber"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "lastseen"
  end

  create_table "groups", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "libraries", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "library_entries", force: true do |t|
    t.integer  "library_id"
    t.integer  "position"
    t.integer  "molecule_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sample_id"
    t.string   "lename"
  end

  create_table "locations", force: true do |t|
    t.integer  "sample_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measurements", force: true do |t|
    t.integer  "dataset_id"
    t.integer  "device_id"
    t.datetime "recorded_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "confirmed",       default: false
    t.integer  "molecule_id"
    t.string   "samplename"
    t.integer  "reaction_id"
    t.integer  "sample_id"
    t.datetime "recorded_end_at"
    t.string   "title"
  end

  create_table "molecule_samples", force: true do |t|
    t.integer  "molecule_id"
    t.integer  "sample_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "molecules", force: true do |t|
    t.string   "smiles"
    t.string   "inchi"
    t.string   "inchikey"
    t.text     "molfile"
    t.float    "mass"
    t.string   "formula"
    t.float    "charge"
    t.float    "spin"
    t.string   "title"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fp",           limit: nil
  end

  create_table "organization_departments", force: true do |t|
    t.integer  "organization_id"
    t.integer  "department_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pc_compounds", force: true do |t|
    t.integer  "cid"
    t.string   "inchikey"
    t.float    "logp"
    t.string   "iupacname"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_beaglebones", force: true do |t|
    t.integer  "beaglebone_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "project_datasets", force: true do |t|
    t.integer  "project_id"
    t.integer  "dataset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "project_devices", force: true do |t|
    t.integer  "project_id"
    t.integer  "device_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "project_folder_watchers", force: true do |t|
    t.integer  "project_id"
    t.integer  "folder_watcher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "project_libraries", force: true do |t|
    t.integer  "project_id"
    t.integer  "library_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "project_memberships", force: true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_molecules", force: true do |t|
    t.integer  "project_id"
    t.integer  "molecule_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "project_reactions", force: true do |t|
    t.integer  "project_id"
    t.integer  "reaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "project_samples", force: true do |t|
    t.integer  "project_id"
    t.integer  "sample_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "project_vncrelays", force: true do |t|
    t.integer  "project_id"
    t.integer  "vncrelay_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "projects", force: true do |t|
    t.string   "title"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rootlibrary_id"
  end

  create_table "reaction_datasets", force: true do |t|
    t.integer  "reaction_id"
    t.integer  "dataset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reactions", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "runs", force: true do |t|
    t.integer  "location_id"
    t.integer  "measurement_id"
    t.integer  "user_id"
    t.datetime "started_at"
    t.datetime "stopped_at"
    t.boolean  "finished",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sample_citations", force: true do |t|
    t.integer  "sample_id"
    t.integer  "citation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sample_reactions", force: true do |t|
    t.integer  "reaction_id"
    t.integer  "sample_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "samples", force: true do |t|
    t.integer  "molecule_id"
    t.string   "guid"
    t.float    "target_amount",       default: 0.0
    t.float    "actual_amount",       default: 0.0
    t.string   "unit"
    t.boolean  "is_virtual",          default: false
    t.float    "equivalent",          default: 1.0
    t.float    "mol",                 default: 0.0
    t.float    "yield"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_startingmaterial", default: false
    t.integer  "originsample_id"
    t.string   "name"
    t.float    "tare_amount",         default: 0.0
    t.integer  "ancestor_id"
  end

  create_table "user_affiliations", force: true do |t|
    t.integer  "user_id"
    t.integer  "affiliation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "sign"
    t.integer  "rootproject_id"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vncrelays", force: true do |t|
    t.string   "host"
    t.string   "port"
    t.datetime "lastseen"
    t.string   "serialnumber"
    t.string   "internal_ip"
    t.string   "external_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
