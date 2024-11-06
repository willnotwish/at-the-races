class RaceResult < ActiveRecord::Base
  belongs_to :race
  has_many :counter_updates

  def success?
    counter_count == 1
  end

  def failure?
    !success?
  end
end
