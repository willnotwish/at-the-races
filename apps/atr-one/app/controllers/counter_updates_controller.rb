class CounterUpdatesController < ApplicationController
  def index
    @race_result = RaceResult.find params[:race_result_id]
    @counter_updates = @race_result.counter_updates
  end

  def show
    @counter_update = CounterUpdate.find params[:id]
  end
end
