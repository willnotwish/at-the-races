class Race < ActiveRecord::Base
  validates(
    :name,
    :description,
    # :race_delay,
    # :lock_timeout,
    # :thread_count,
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

  has_many :race_results
end
