class RaceConfig < ActiveRecord::Base
  validates :name, :description, :race_delay, :lock_timeout, :thread_count, presence: true
  validates :race_delay, :lock_timeout, :thread_count, numericality: { only_integer: true }
end
