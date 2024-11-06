class RacesController < ApplicationController
  before_action :set_race, only: [:show, :edit, :update, :destroy]

  def index
    @races = Race.all
  end

  def show
    @race_results = @race.race_results
  end

  def new
    @race_config = RaceConfig.find params[:race_config_id]
    @race = Race.new(@race_config.attributes)
    @race.update_count = 100

    @processors = AtrOne::Container.keys
                                   .select { |key| key =~ /^.*_processor$/ }
                                   .map { |name| [name.humanize, name] }
    @drivers = AtrOne::Container.keys
                                .select { |key| key =~ /^.*_driver$/ }
                                .map { |name| [name.humanize, name] }
    @months = Month.all.map { |month| [month.name, month.code] }
  end

  def create
    # Uses dry-transaction
    Races::CreateTransaction
      .new
      .tap { |creation| creation.subscribe(StepLogger.new) }
      .call(race_params) do |match|
        match.success { |race_result| redirect_to(race_result, info: 'Race over') }

        match.failure(:check_params) { |errors| raise ActionController::BadRequest, errors.to_s }
    
        # match.failure(:build_model) do |record|
        #   @form = record
        #   render(action_to_render_on_failure, status: :unprocessable_entity)
        # end
    
        match.failure { |error| raise error }
    
      end
  end

  private
    def set_race
      @race = Race.find(params[:id])
    end

    def race_params
      params
        .require(:race)
        .permit(
          :name,
          :description,
          :race_delay,
          :thread_count,
          :lock_timeout,
          :update_count,
          :month_code,
          :counter_code
        )
    end
end
