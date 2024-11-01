class RaceResult < ActiveRecord::Base
  belongs_to :race

  def success?
    counter_count == 1
  end

  def failure?
    !success?
  end
end
