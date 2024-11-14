# frozen_string_literal: true

# create_table "races", force: :cascade do |t|
#   t.string   "name",         limit: 255
#   t.text     "description",  limit: 65535
#   t.integer  "race_delay",   limit: 4
#   t.integer  "thread_count", limit: 4
#   t.integer  "lock_timeout", limit: 4
#   t.integer  "update_count", limit: 4
#   t.string   "month_code",   limit: 255
#   t.string   "counter_code", limit: 255
#   t.datetime "created_at",                 null: false
#   t.datetime "updated_at",                 null: false
#   t.string   "processor",    limit: 255
#   t.string   "driver",       limit: 255
# end

class Race < ActiveRecord::Base
  validates(
    :name,
    :description,
    :month_code,
    :counter_code,
    :processor,
    :driver,
    presence: true
  )

  validates(
    :update_count,
    :race_delay,
    :lock_timeout,
    :thread_count,
    numericality: { only_integer: true }
  )

  # Each time a race is run it generates a set of results
  has_many :race_results
end
