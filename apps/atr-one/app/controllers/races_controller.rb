class RacesController < ApplicationController
  helper_method :pubnub_config, :centrifugo_config

  before_action :set_race, only: [:show, :edit, :update, :destroy, :start]
  
  skip_before_action :verify_authenticity_token, only: [:start]
  
  def index
    @races = Race.all
  end

  def show
    @race_results = @race.race_results
    
    render layout: 'visualization'
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
    @race = Race.create!(race_params)
    redirect_to @race, notice: 'Race saved'
  end

  def start
    StartRaceJob.perform_later(@race.id)

    # DEBUGGING. Always return JSON response for now
    render json: @race.to_json
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
        :counter_code,
        :processor,
        :driver
      )
  end

  def pubnub_config
    @pubnub_config ||= AtrOne::Container['pubnub'].env
                                                  .slice(:subscribe_key, :user_id)
                                                  .merge(channel: 'at-the-races')
                                                  .symbolize_keys
  end

  def centrifugo_config
    @centrifugo_config ||= build_centrifugo_config
  end

  def build_centrifugo_config
    {
      ws_url: ENV['CENTRIFUGO_WS_URL'],
      token: new_centrifugo_connection_token,
      channel: 'at-the-races' 
    }
  end

  def new_centrifugo_connection_token
    AtrOne::Container['centrifugo.notary'].issue_connection_token(sub: '42')
  end
end
