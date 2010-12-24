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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101224181255) do

  create_table "analogues", :force => true do |t|
    t.integer  "original_id"
    t.integer  "analogue_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "auto_options", :force => true do |t|
    t.integer  "auto_id"
    t.integer  "period_id"
    t.integer  "transmission_id"
    t.integer  "gear_id"
    t.integer  "fuel_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "autos", :force => true do |t|
    t.integer  "manufacturer_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "column_relations", :force => true do |t|
    t.integer  "catalog_number"
    t.integer  "manufacturer"
    t.integer  "cost"
    t.integer  "title"
    t.integer  "weight"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "convert_jobs", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "convert_method"
    t.string   "encoding_in"
    t.string   "col_sep"
    t.string   "encoding_out"
    t.string   "exec_string"
  end

  create_table "currencies", :force => true do |t|
    t.string   "title"
    t.string   "foreign_id"
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "delivery_types", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "discount_groups", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "discount_rules", :force => true do |t|
    t.integer  "job_id"
    t.boolean  "buy_sell"
    t.float    "rate"
    t.integer  "discount_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_receives", :force => true do |t|
    t.string   "server"
    t.string   "port"
    t.boolean  "ssl"
    t.string   "login"
    t.string   "password"
    t.string   "protocol"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_settings", :force => true do |t|
    t.string   "sender"
    t.string   "topic"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "filter_jobs", :force => true do |t|
    t.string   "first"
    t.string   "second"
    t.string   "third"
    t.string   "fourth"
    t.string   "fifth"
    t.string   "sixth"
    t.string   "seventh"
    t.string   "eighth"
    t.string   "ninth"
    t.string   "tenth"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "col_sep"
    t.string   "row_sep"
    t.string   "quote_char"
    t.string   "converters"
    t.string   "encoding"
    t.string   "field_size_limit"
    t.string   "unconverted_fields"
    t.string   "headers"
    t.string   "return_headers"
    t.string   "write_headers"
    t.string   "header_converters"
    t.string   "skip_blanks"
    t.string   "force_quotes"
  end

  create_table "folder_receives", :force => true do |t|
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ftp_receives", :force => true do |t|
    t.string   "server",     :default => "ftp.avtorif.ru"
    t.integer  "port",       :default => 21
    t.string   "path",       :default => "/"
    t.string   "login",      :default => "anonymous"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fuels", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gears", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "goods", :force => true do |t|
    t.string   "catalog_number"
    t.integer  "manufacturer_id"
    t.boolean  "original"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "goods_auto_options", :force => true do |t|
    t.integer  "goods_id"
    t.integer  "auto_option_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "http_receives", :force => true do |t|
    t.string   "server"
    t.string   "port",       :default => "80"
    t.string   "path"
    t.string   "login"
    t.string   "password"
    t.boolean  "ssl"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "import_jobs", :force => true do |t|
    t.integer  "importable_id"
    t.string   "importable_type"
    t.string   "import_method"
    t.boolean  "presence"
    t.integer  "currency_buy_id"
    t.integer  "currency_sell_id"
    t.integer  "currency_weight_id"
    t.integer  "delivery_type_id"
    t.boolean  "visible_for_site"
    t.boolean  "visible_for_stock"
    t.boolean  "visible_for_shops"
    t.integer  "estimate_days"
    t.float    "retail_rate"
    t.float    "income_rate"
    t.float    "kilo_price"
    t.float    "weight_unavaliable_rate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "manufacturer_colnum"
    t.integer  "catalog_number_colnum"
    t.integer  "title_colnum"
    t.integer  "count_colnum"
    t.integer  "multiplicity_colnum"
    t.integer  "income_price_colnum"
    t.integer  "external_id_colnum"
    t.integer  "weight_colnum"
    t.string   "country"
    t.string   "country_short"
    t.string   "delivery_summary"
    t.integer  "delivery_days_declared"
    t.integer  "delivery_days_average"
    t.string   "success_percent"
    t.string   "default_manufacturer"
    t.integer  "applicability_colnum"
    t.integer  "unit_colnum"
    t.integer  "description_colnum"
    t.integer  "min_order_colnum"
    t.integer  "multiply_factor_colnum"
    t.integer  "unit_package_colnum"
    t.integer  "title_en_colnum"
    t.integer  "country_colnum"
    t.integer  "replacement_colnum"
    t.string   "replacement_delimiter"
    t.integer  "r0_colnum"
    t.integer  "r1_colnum"
    t.integer  "r2_colnum"
    t.integer  "r3_colnum"
    t.integer  "r4_colnum"
    t.integer  "r5_colnum"
    t.integer  "r6_colnum"
    t.integer  "r7_colnum"
    t.integer  "r8_colnum"
    t.integer  "r9_colnum"
    t.float    "weight_koefficient"
    t.integer  "new_catalog_number_colnum"
    t.float    "absolute_buy_currency"
    t.float    "relative_buy_currency"
    t.float    "absolute_weight_currency"
    t.float    "relative_weight_currency"
  end

  create_table "jobs", :force => true do |t|
    t.datetime "next_start"
    t.datetime "last_start"
    t.datetime "last_finish"
    t.integer  "seconds_between_jobs"
    t.integer  "seconds_working"
    t.string   "title"
    t.integer  "job_id"
    t.integer  "jobable_id"
    t.string   "jobable_type"
    t.integer  "supplier_id"
    t.string   "file_mask"
    t.boolean  "locked",               :default => false
    t.boolean  "active",               :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.boolean  "started_once"
    t.text     "last_error"
  end

  create_table "jobs_repeats", :id => false, :force => true do |t|
    t.integer  "repeat_id"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "manufacturers", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mies", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "periods", :force => true do |t|
    t.integer  "thousand_kilometers"
    t.integer  "months"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prices", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
    t.string   "new_catalog_number"
    t.float    "weight_grams"
    t.string   "r0"
    t.string   "r1"
    t.string   "r2"
    t.string   "r3"
    t.string   "r4"
    t.string   "r5"
    t.string   "r6"
    t.string   "r7"
    t.string   "r8"
    t.string   "r9"
  end

  create_table "prices_1066346320", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346346", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346347", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346351", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346352", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346353", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346354", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346360", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346361", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346362", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346364", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346369", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
    t.string   "new_catalog_number"
    t.float    "weight_grams"
    t.string   "r0"
    t.string   "r1"
    t.string   "r2"
    t.string   "r3"
    t.string   "r4"
    t.string   "r5"
    t.string   "r6"
    t.string   "r7"
    t.string   "r8"
    t.string   "r9"
  end

  create_table "prices_1066346370", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346372", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346375", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
    t.string   "new_catalog_number"
    t.float    "weight_grams"
    t.string   "r0"
    t.string   "r1"
    t.string   "r2"
    t.string   "r3"
    t.string   "r4"
    t.string   "r5"
    t.string   "r6"
    t.string   "r7"
    t.string   "r8"
    t.string   "r9"
  end

  create_table "prices_1066346376", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346377", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346378", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346379", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346381", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346382", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346383", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346384", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346390", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346391", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346392", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346393", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346394", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346396", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346398", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346399", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346400", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346401", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346402", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346403", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346404", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346405", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346406", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346421", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346422", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346423", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346424", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346425", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346426", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346427", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346428", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346429", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346430", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346431", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346432", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346433", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346434", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346435", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346436", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346447", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
  end

  create_table "prices_1066346449", :force => true do |t|
    t.integer  "job_id"
    t.integer  "goods_id"
    t.string   "title"
    t.string   "count"
    t.decimal  "price_cost",         :precision => 10, :scale => 3
    t.string   "manufacturer"
    t.string   "catalog_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "title_en"
    t.string   "manufacturer_short"
    t.string   "success_percent"
    t.string   "applicability"
    t.string   "unit"
    t.string   "description"
    t.string   "min_order"
    t.string   "multiply_factor"
    t.string   "unit_package"
    t.string   "external_id"
    t.string   "new_catalog_number"
    t.float    "weight_grams"
    t.string   "r0"
    t.string   "r1"
    t.string   "r2"
    t.string   "r3"
    t.string   "r4"
    t.string   "r5"
    t.string   "r6"
    t.string   "r7"
    t.string   "r8"
    t.string   "r9"
  end

  create_table "receive_jobs", :force => true do |t|
    t.integer  "receiveable_id"
    t.string   "receiveable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "repeats", :force => true do |t|
    t.string   "cron_string"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "smb_receives", :force => true do |t|
    t.string   "server",     :default => "rif2010"
    t.string   "share"
    t.integer  "port",       :default => 445
    t.string   "path",       :default => "/"
    t.string   "login",      :default => "office"
    t.string   "password",   :default => "2"
    t.string   "workgroup"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "supplier_prices", :force => true do |t|
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.string   "attachment_file_size",    :limit => 20
    t.datetime "attachment_updated_at"
    t.string   "md5",                     :limit => 50
    t.integer  "supplier_id"
    t.string   "email_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "job_code"
    t.integer  "job_id"
    t.string   "wc_stat"
    t.string   "group_code"
  end

  create_table "suppliers", :force => true do |t|
    t.string   "title"
    t.string   "inn",                    :limit => 12
    t.string   "kpp",                    :limit => 9
    t.string   "login"
    t.string   "password"
    t.string   "contact_info"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title_short"
    t.string   "title_en"
    t.string   "title_full"
    t.string   "okpo"
    t.string   "okato"
    t.string   "ogrn"
    t.string   "legal_address"
    t.string   "actual_address"
    t.string   "bik_bank"
    t.string   "bank_title"
    t.string   "current_account"
    t.string   "correspondent_account"
    t.string   "buyer"
    t.string   "seller"
    t.string   "contract"
    t.string   "fio_head"
    t.string   "position_head"
    t.string   "fio_buh"
    t.string   "phone"
    t.string   "fax"
    t.string   "email"
    t.string   "emaildocs"
    t.integer  "discount_group_id"
    t.integer  "delivery_days_declared"
    t.integer  "delivery_days_average"
  end

  create_table "transmissions", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unpack_jobs", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
