class MissionsController < ApplicationController
  before_action :set_mission, only: [:show, :edit, :update, :destroy, :capture], if: :is_valid_id?

  # GET /missions
  # GET /missions.json
  def index
    @missions = Mission.all
  end

  # GET /missions/1
  # GET /missions/1.json
  def show
    @missions = Mission.all
    show_clams = Clam.where("mission_id IS ?", nil)
    show_clams = show_clams.search(params[:search]) if params[:search]
    show_clams = show_clams.narrow_by_reuseinfo if params[:narrow]
    @clams = @mission ? @mission.clams : show_clams.order("date desc")
  end

  # GET /missions/new
  def new
    @mission = Mission.new
  end

  # GET /missions/1/edit
  def edit
  end

  # POST /missions
  # POST /missions.json
  def create
    @mission = Mission.new(mission_params)

    respond_to do |format|
      if @mission.save
        format.html { redirect_to @mission, notice: 'Mission was successfully created.' }
        format.json { render :show, status: :created, location: @mission }
      else
        format.html { render :new }
        format.json { render json: @mission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /missions/1
  # PATCH/PUT /missions/1.json
  def update
    respond_to do |format|
      if @mission.update(mission_params)
        format.html { redirect_to @mission, notice: 'Mission was successfully updated.' }
        format.json { render :show, status: :ok, location: @mission }
      else
        format.html { render :edit }
        format.json { render json: @mission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /missions/1
  # DELETE /missions/1.json
  def destroy
    @mission.destroy
    respond_to do |format|
      format.html { redirect_to missions_url, notice: 'Mission was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def capture
    Clam.transaction do
      clam = Clam.create!(params[:clam])
      clam.resource = Resource.create!(params[:resource])
      if @mission.present?
        @mission.clam = clam
        @Mission.save!
      end
      render json: clam, include: :resource
    end
    rescue => e
      render json: e.message, status: :unprocessable_entity
  end

  def events
    mission_id = params[:id]
    events = Event.where("mission_id is ?", mission_id)
    respond_to do |format|
      format.json { render json: events }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mission
      @mission = Mission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mission_params
      params.require(:mission).permit(:name, :description, :deadline, :state_id, :keyword, :parent_id, :lft, :rgt, :depth)
    end

    def is_valid_id?
      params[:id].to_i != 0
    end
end
