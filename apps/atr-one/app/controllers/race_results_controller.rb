class RaceResultsController < ApplicationController
  def index
    @race_results = RaceResult.all
  end

  def show
    @race_result = RaceResult.find params[:id]
    @race = @race_result.race
  end
end
