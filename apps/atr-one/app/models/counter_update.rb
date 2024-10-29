class CounterUpdate < ActiveRecord::Base
  validates :counter_code, :month_code, :value, presence: true
end
