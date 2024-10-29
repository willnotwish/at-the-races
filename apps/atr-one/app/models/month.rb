class Month < ActiveRecord::Base
  has_many :counters
end
