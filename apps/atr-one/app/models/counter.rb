class Counter < ActiveRecord::Base
  belongs_to :month, required: true
end
