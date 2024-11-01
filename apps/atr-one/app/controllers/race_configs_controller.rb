class RaceConfigsController < ApplicationController
  before_action :set_race_config, only: [:show, :edit, :update, :destroy]

  def index
    @race_configs = RaceConfig.all
  end

  def show
  end

  def new
    @race_config = RaceConfig.new
  end

  # GET /race_configs/1/edit
  def edit
  end

  # POST /race_configs
  # POST /race_configs.json
  def create
    @race_config = RaceConfig.new(race_config_params)

    respond_to do |format|
      if @race_config.save
        format.html { redirect_to @race_config, notice: 'Race config was successfully created.' }
        format.json { render :show, status: :created, location: @race_config }
      else
        format.html { render :new }
        format.json { render json: @race_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /race_configs/1
  # PATCH/PUT /race_configs/1.json
  def update
    respond_to do |format|
      if @race_config.update(race_config_params)
        format.html { redirect_to @race_config, notice: 'Race config was successfully updated.' }
        format.json { render :show, status: :ok, location: @race_config }
      else
        format.html { render :edit }
        format.json { render json: @race_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /race_configs/1
  # DELETE /race_configs/1.json
  def destroy
    @race_config.destroy
    respond_to do |format|
      format.html { redirect_to race_configs_url, notice: 'Race config was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_race_config
      @race_config = RaceConfig.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def race_config_params
      params.require(:race_config).permit(:name, :description, :thread_count, :race_delay, :lock_timeout)
    end
end
