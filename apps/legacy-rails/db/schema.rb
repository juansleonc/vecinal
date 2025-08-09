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

ActiveRecord::Schema.define(version: 20190917200231) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_balances", force: :cascade do |t|
    t.string   "subject"
    t.date     "publication_date"
    t.integer  "user_id"
    t.integer  "community_id"
    t.string   "community_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "account_balances", ["user_id"], name: "index_account_balances_on_user_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "failed_attempts",                    default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "amenities", force: :cascade do |t|
    t.integer  "building_id"
    t.string   "name",                           limit: 255
    t.text     "description"
    t.boolean  "rental_fee",                                                          default: false
    t.decimal  "rental_value",                               precision: 11, scale: 2
    t.boolean  "deposit",                                                             default: false
    t.decimal  "deposit_value",                              precision: 11, scale: 2
    t.integer  "maximun_rental_time"
    t.string   "availability_type",              limit: 255,                          default: "selected_hours"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.float    "reservation_length",                                                  default: 1.0
    t.string   "reservation_length_type",                                             default: "hours"
    t.integer  "max_reservations_per_user",                                           default: 1
    t.string   "max_reservations_per_user_type",                                      default: "days"
    t.boolean  "auto_approval",                                                       default: false
    t.float    "reservation_interval",                                                default: 1.0
  end

  add_index "amenities", ["building_id"], name: "index_amenities_on_building_id", using: :btree
  add_index "amenities", ["deleted_at"], name: "index_amenities_on_deleted_at", using: :btree

  create_table "apartments", force: :cascade do |t|
    t.integer  "building_id"
    t.string   "apartment_number",       limit: 255
    t.string   "category",               limit: 255
    t.date     "available_at"
    t.string   "show_price",             limit: 255
    t.integer  "price"
    t.integer  "size_ft2"
    t.string   "bedrooms",               limit: 255
    t.string   "bathrooms",              limit: 255
    t.boolean  "furnished"
    t.boolean  "pets"
    t.string   "show_contact",           limit: 255
    t.string   "secondary_phone_number", limit: 255
    t.string   "secondary_email",        limit: 255
    t.string   "title",                  limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "apartments", ["building_id"], name: "index_apartments_on_building_id", using: :btree

  create_table "attachments", force: :cascade do |t|
    t.string   "attachmentable_type",          limit: 255
    t.integer  "attachmentable_id"
    t.string   "file_attachment_file_name",    limit: 255
    t.string   "file_attachment_content_type", limit: 255
    t.integer  "file_attachment_file_size"
    t.datetime "file_attachment_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.datetime "deleted_at"
  end

  add_index "attachments", ["created_by_id"], name: "index_attachments_on_created_by_id", using: :btree
  add_index "attachments", ["deleted_at"], name: "index_attachments_on_deleted_at", using: :btree

  create_table "availabilities", force: :cascade do |t|
    t.integer  "day"
    t.time     "time_from"
    t.time     "time_to"
    t.boolean  "active",     default: true
    t.integer  "amenity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "availabilities", ["amenity_id"], name: "index_availabilities_on_amenity_id", using: :btree

  create_table "buildings", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "code",                       limit: 255
    t.string   "name",                       limit: 255
    t.string   "subdomain",                  limit: 255
    t.text     "description"
    t.integer  "size"
    t.string   "category",                   limit: 255
    t.string   "address",                    limit: 255
    t.string   "city",                       limit: 255
    t.string   "region",                     limit: 255
    t.string   "country",                    limit: 255
    t.string   "zip",                        limit: 255
    t.string   "logo_file_name",             limit: 255
    t.string   "logo_content_type",          limit: 255
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "country_code",               limit: 3
    t.string   "phone"
    t.string   "email"
    t.string   "website"
    t.string   "opening_hours"
    t.string   "community_id",                           default: ""
    t.text     "billing_information",                    default: ""
    t.integer  "admin_default_requests",                 default: 0
    t.integer  "admin_default_reservations",             default: 0
    t.string   "managed_by"
  end

  create_table "businesses", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "code",                       limit: 255
    t.string   "name",                       limit: 255
    t.string   "phone",                      limit: 255
    t.string   "extension",                  limit: 255
    t.string   "country",                    limit: 255
    t.string   "region",                     limit: 255
    t.string   "city",                       limit: 255
    t.string   "address",                    limit: 255
    t.string   "zip",                        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace",                  limit: 255
    t.string   "description",                limit: 255
    t.float    "latitude"
    t.float    "longitude"
    t.string   "logo_file_name",             limit: 255
    t.string   "logo_content_type",          limit: 255
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "email",                      limit: 255
    t.string   "opening_hours",              limit: 255
    t.string   "website",                    limit: 255
    t.string   "stripe_user_id",             limit: 255
    t.string   "stripe_publishable_key",     limit: 255
    t.string   "stripe_customer_id",         limit: 255
    t.string   "stripe_subscription_plan",   limit: 255
    t.string   "stripe_subscription_status", limit: 255
    t.string   "location",                   limit: 255
  end

  add_index "businesses", ["user_id"], name: "index_businesses_on_user_id", using: :btree

  create_table "classifieds", force: :cascade do |t|
    t.string   "title",        limit: 255
    t.decimal  "price",                    precision: 11, scale: 2
    t.text     "description"
    t.integer  "publisher_id"
    t.integer  "building_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: :cascade do |t|
    t.string   "commentable_type", limit: 255
    t.integer  "commentable_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "comments", ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
  add_index "comments", ["deleted_at"], name: "index_comments_on_deleted_at", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "companies", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "code",                       limit: 255
    t.string   "name",                       limit: 255
    t.string   "namespace",                  limit: 255
    t.string   "email",                      limit: 255
    t.string   "phone",                      limit: 255
    t.string   "extension",                  limit: 255
    t.string   "country",                    limit: 255
    t.string   "region",                     limit: 255
    t.string   "city",                       limit: 255
    t.string   "address",                    limit: 255
    t.string   "zip",                        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fax",                        limit: 255
    t.string   "opening_hours",              limit: 255
    t.string   "website",                    limit: 255
    t.text     "description"
    t.string   "logo_file_name",             limit: 255
    t.string   "logo_content_type",          limit: 255
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "category",                   limit: 255
    t.float    "latitude"
    t.float    "longitude"
    t.string   "stripe_customer_id",         limit: 255
    t.string   "stripe_subscription_plan",   limit: 255
    t.string   "stripe_subscription_status", limit: 255
    t.string   "location",                   limit: 255
    t.string   "managed_by"
  end

  add_index "companies", ["user_id"], name: "index_companies_on_user_id", using: :btree

  create_table "contact_details", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "phone",                   limit: 255
    t.string   "emergency_contact_name",  limit: 255
    t.string   "emergency_contact_phone", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "move_in_date"
    t.string   "sex",                     limit: 255
    t.string   "work",                    limit: 255
    t.string   "education",               limit: 255
    t.date     "birth_day"
    t.integer  "birth_year"
    t.string   "mobile_phone",            limit: 255
    t.string   "garage",                  limit: 255
    t.string   "locker",                  limit: 255
    t.string   "links",                   limit: 255
    t.string   "relationship",            limit: 255
    t.string   "hometown",                limit: 255
    t.text     "apartment_numbers"
  end

  create_table "coupon_redemptions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "coupon_id"
    t.boolean  "redeemed",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coupon_redemptions", ["coupon_id"], name: "index_coupon_redemptions_on_coupon_id", using: :btree
  add_index "coupon_redemptions", ["user_id"], name: "index_coupon_redemptions_on_user_id", using: :btree

  create_table "deal_purchases", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "deal_id"
    t.decimal  "price",                        precision: 11, scale: 2
    t.string   "status",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_charge_id", limit: 255
    t.integer  "quantity",                                              default: 1
    t.string   "address",          limit: 255
    t.string   "city",             limit: 255
    t.string   "region",           limit: 255
    t.string   "country",          limit: 255
  end

  add_index "deal_purchases", ["deal_id"], name: "index_deal_purchases_on_deal_id", using: :btree
  add_index "deal_purchases", ["user_id"], name: "index_deal_purchases_on_user_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.integer  "sender_id"
    t.string   "title",      limit: 255
    t.date     "date"
    t.string   "location",   limit: 255
    t.text     "details"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "rsvp"
    t.time     "time_from"
    t.time     "time_to"
    t.datetime "deleted_at"
  end

  add_index "events", ["date"], name: "index_events_on_date", using: :btree
  add_index "events", ["deleted_at"], name: "index_events_on_deleted_at", using: :btree
  add_index "events", ["sender_id"], name: "index_events_on_sender_id", using: :btree
  add_index "events", ["title"], name: "index_events_on_title", using: :btree

  create_table "events_users", force: :cascade do |t|
    t.integer "event_id"
    t.integer "user_id"
  end

  add_index "events_users", ["event_id"], name: "index_events_users_on_event_id", using: :btree
  add_index "events_users", ["user_id"], name: "index_events_users_on_user_id", using: :btree

  create_table "folders", force: :cascade do |t|
    t.integer  "father_id"
    t.integer  "created_by_id"
    t.integer  "folderable_id"
    t.string   "folderable_type", limit: 255
    t.string   "name",            limit: 255
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "size",                        default: 0
  end

  add_index "folders", ["created_by_id"], name: "index_folders_on_created_by_id", using: :btree
  add_index "folders", ["father_id"], name: "index_folders_on_father_id", using: :btree
  add_index "folders", ["folderable_id", "folderable_type"], name: "index_folders_on_folderable_id_and_folderable_type", using: :btree

  create_table "images", force: :cascade do |t|
    t.integer  "imageable_id"
    t.string   "imageable_type",     limit: 255
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "home"
  end

  add_index "images", ["imageable_type", "imageable_id"], name: "index_images_on_imageable_type_and_imageable_id", using: :btree

  create_table "invites", force: :cascade do |t|
    t.integer  "inviter_id"
    t.string   "email",            limit: 255
    t.string   "accountable_type", limit: 255
    t.integer  "accountable_id"
    t.string   "role",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "apartment_number"
  end

  add_index "invites", ["email"], name: "index_invites_on_email", using: :btree
  add_index "invites", ["inviter_id"], name: "index_invites_on_inviter_id", using: :btree

  create_table "likes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "likeable_id"
    t.string   "likeable_type"
    t.string   "name",          default: "like"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "likes", ["user_id", "likeable_id", "likeable_type"], name: "index_likes_on_user_id_and_likeable_id_and_likeable_type", unique: true, using: :btree

  create_table "markers", id: false, force: :cascade do |t|
    t.integer  "markable_id"
    t.string   "markable_type", limit: 255
    t.integer  "user_id"
    t.string   "label",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "markers", ["markable_type", "markable_id"], name: "index_markers_on_markable_type_and_markable_id", using: :btree
  add_index "markers", ["user_id"], name: "index_markers_on_user_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "sender_id"
    t.string   "title",      limit: 255
    t.text     "content"
    t.boolean  "urgent"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.boolean  "warning",                default: false
  end

  add_index "messages", ["deleted_at"], name: "index_messages_on_deleted_at", using: :btree
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id", using: :btree

  create_table "messages_users", force: :cascade do |t|
    t.integer "message_id"
    t.integer "user_id"
  end

  add_index "messages_users", ["message_id"], name: "index_messages_users_on_message_id", using: :btree
  add_index "messages_users", ["user_id"], name: "index_messages_users_on_user_id", using: :btree

  create_table "payment_accounts", force: :cascade do |t|
    t.integer  "building_id"
    t.string   "status",             limit: 255
    t.string   "bank_name",          limit: 255
    t.string   "account_name",       limit: 255
    t.string   "account_number",     limit: 255
    t.string   "account_type",       limit: 255
    t.string   "transit_number",     limit: 255
    t.string   "institution_number", limit: 255
    t.string   "routing_number",     limit: 255
    t.boolean  "enable_payments"
    t.string   "cust_id_cliente",    limit: 255
    t.string   "public_key",         limit: 255
    t.string   "country",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payment_accounts", ["building_id"], name: "index_payment_accounts_on_building_id", using: :btree

  create_table "payment_fees", force: :cascade do |t|
    t.string   "platform",              limit: 255
    t.decimal  "bank_discount_percent",             precision: 5, scale: 2
    t.decimal  "platform_fee",                      precision: 8, scale: 2
    t.decimal  "cm_fee",                            precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "payment_account_id"
    t.integer  "cust_id_cliente"
    t.string   "description",          limit: 255
    t.decimal  "amount_ok",                        precision: 11, scale: 2
    t.decimal  "amount_base",                      precision: 11, scale: 2
    t.integer  "tax"
    t.decimal  "service_fee",                      precision: 8,  scale: 2
    t.string   "id_invoice",           limit: 255
    t.string   "currency_code",        limit: 3
    t.string   "bank_name",            limit: 255
    t.string   "cardnumber",           limit: 255
    t.string   "business",             limit: 255
    t.integer  "instalment"
    t.string   "franchise",            limit: 255
    t.datetime "transaction_date"
    t.integer  "approval_code"
    t.integer  "transaction_id"
    t.string   "response",             limit: 255
    t.string   "errorcode",            limit: 255
    t.string   "customer_doctype",     limit: 10
    t.string   "customer_document",    limit: 255
    t.string   "customer_name",        limit: 255
    t.string   "customer_lastname",    limit: 255
    t.string   "customer_email",       limit: 255
    t.string   "customer_phone",       limit: 255
    t.string   "customer_country",     limit: 3
    t.string   "customer_city",        limit: 255
    t.string   "customer_address",     limit: 255
    t.string   "customer_ip",          limit: 16
    t.decimal  "amount_country",                   precision: 11, scale: 2
    t.decimal  "amount",                           precision: 11, scale: 2
    t.integer  "cod_response",         limit: 2
    t.string   "response_reason_text", limit: 255
    t.string   "signature",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "payments", ["deleted_at"], name: "index_payments_on_deleted_at", using: :btree
  add_index "payments", ["payment_account_id"], name: "index_payments_on_payment_account_id", using: :btree
  add_index "payments", ["user_id"], name: "index_payments_on_user_id", using: :btree

  create_table "poll_answers", force: :cascade do |t|
    t.integer  "poll_id"
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "poll_votes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "poll_id"
    t.integer  "poll_answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "poll_votes", ["deleted_at"], name: "index_poll_votes_on_deleted_at", using: :btree
  add_index "poll_votes", ["poll_id", "user_id"], name: "index_poll_votes_on_poll_id_and_user_id", unique: true, using: :btree

  create_table "polls", force: :cascade do |t|
    t.integer  "publisher_id"
    t.integer  "building_id"
    t.string   "question",     limit: 255
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "polls", ["deleted_at"], name: "index_polls_on_deleted_at", using: :btree

  create_table "promotions", force: :cascade do |t|
    t.integer  "business_id"
    t.string   "type",                    limit: 255
    t.string   "category",                limit: 255
    t.string   "title",                   limit: 255
    t.decimal  "price",                               precision: 11, scale: 2
    t.integer  "discount"
    t.integer  "number"
    t.datetime "available_at"
    t.datetime "finish_at"
    t.text     "description"
    t.text     "fine_print"
    t.string   "show_contact",            limit: 255
    t.string   "secondary_phone_number",  limit: 255
    t.string   "secondary_email",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "highlight"
    t.datetime "top"
    t.string   "stripe_highlight_charge", limit: 255
    t.string   "stripe_top_charge",       limit: 255
    t.datetime "last_day_to_claim"
    t.boolean  "requires_shipping"
    t.integer  "impressions",                                                  default: 0
    t.integer  "clicks",                                                       default: 0
  end

  add_index "promotions", ["business_id"], name: "index_promotions_on_business_id", using: :btree
  add_index "promotions", ["title", "price"], name: "index_promotions_on_title_and_price", using: :btree

  create_table "read_marks", force: :cascade do |t|
    t.integer  "readable_id"
    t.integer  "reader_id",                null: false
    t.string   "readable_type", limit: 20, null: false
    t.datetime "timestamp"
    t.string   "reader_type"
  end

  add_index "read_marks", ["reader_id", "reader_type", "readable_type", "readable_id"], name: "read_marks_reader_readable_index", unique: true, using: :btree

  create_table "reservations", force: :cascade do |t|
    t.date     "date"
    t.time     "time_from"
    t.time     "time_to"
    t.string   "status",         limit: 255
    t.string   "payment",        limit: 255
    t.text     "message"
    t.integer  "reserver_id"
    t.integer  "amenity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "responsible_id",             default: 0
  end

  add_index "reservations", ["amenity_id"], name: "index_reservations_on_amenity_id", using: :btree
  add_index "reservations", ["deleted_at"], name: "index_reservations_on_deleted_at", using: :btree
  add_index "reservations", ["reserver_id"], name: "index_reservations_on_reserver_id", using: :btree

  create_table "reviews", force: :cascade do |t|
    t.integer  "rank"
    t.string   "comment",         limit: 255
    t.integer  "user_id"
    t.integer  "reviewable_id"
    t.string   "reviewable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reviews", ["reviewable_id", "reviewable_type"], name: "index_reviews_on_reviewable_id_and_reviewable_type", using: :btree
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id", using: :btree

  create_table "service_requests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "responsible_id"
    t.string   "responsible_type", limit: 255
    t.string   "title",            limit: 255
    t.text     "content"
    t.boolean  "urgent"
    t.string   "category",         limit: 255
    t.string   "status",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rate_score",                   default: 0
    t.datetime "deleted_at"
  end

  add_index "service_requests", ["deleted_at"], name: "index_service_requests_on_deleted_at", using: :btree
  add_index "service_requests", ["responsible_id", "responsible_type"], name: "index_service_requests_on_responsible_id_and_responsible_type", using: :btree
  add_index "service_requests", ["user_id"], name: "index_service_requests_on_user_id", using: :btree

  create_table "settings", force: :cascade do |t|
    t.integer  "settingable_id"
    t.string   "settingable_type"
    t.string   "name"
    t.text     "value"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "settings", ["settingable_type", "settingable_id"], name: "index_settings_on_settingable_type_and_settingable_id", using: :btree

  create_table "shares", force: :cascade do |t|
    t.integer "shareable_id"
    t.string  "shareable_type"
    t.integer "recipientable_id"
    t.string  "recipientable_type"
  end

  add_index "shares", ["recipientable_type", "recipientable_id"], name: "index_shares_on_recipientable_type_and_recipientable_id", using: :btree
  add_index "shares", ["shareable_type", "shareable_id"], name: "index_shares_on_shareable_type_and_shareable_id", using: :btree

  create_table "user_balance_items", force: :cascade do |t|
    t.string   "reference_code"
    t.string   "concept"
    t.string   "previous_balance"
    t.string   "current_payment"
    t.string   "total"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_balance_id"
  end

  create_table "user_balances", force: :cascade do |t|
    t.string   "resident_name"
    t.string   "apartment_number"
    t.integer  "billing_number"
    t.string   "previous_payment"
    t.string   "total"
    t.integer  "account_balance_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_balances", ["account_balance_id"], name: "index_user_balances_on_account_balance_id", using: :btree

  create_table "user_balances_users", id: false, force: :cascade do |t|
    t.integer "user_id",         null: false
    t.integer "user_balance_id", null: false
  end

  add_index "user_balances_users", ["user_id", "user_balance_id"], name: "index_user_balances_users_on_user_id_and_user_balance_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.string   "role",                   limit: 255
    t.string   "accountable_type",       limit: 255
    t.integer  "accountable_id"
    t.boolean  "accepted",                           default: false
    t.string   "logo_file_name",         limit: 255
    t.string   "logo_content_type",      limit: 255
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "locale",                 limit: 2,   default: "en"
    t.boolean  "tour_taken"
    t.datetime "deleted_at"
    t.boolean  "change_password",                    default: false
    t.integer  "create_by_admin",                    default: 0
  end

  add_index "users", ["accountable_id", "accountable_type"], name: "index_users_on_accountable_id_and_accountable_type", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
