class Race < ActiveRecord::Base
  validates(
    :name,
    :description,
    :month_code,
    :counter_code,
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
