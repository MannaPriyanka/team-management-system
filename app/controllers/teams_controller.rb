class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: [:show, :update, :destroy]
  before_action :authorize_owner!, only: [:update, :destroy]

  def index
    @teams = current_user.teams.page(params[:page]).per(params[:per_page] || 10)
    render json: @teams
  end

  def create
    @team = current_user.teams.build(team_params)
    if @team.save
      render json: @team, status: :created
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @team
  end

  def update
    if @team.update(team_params)
      render json: @team
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @team.destroy
    head :no_content
  end

  private

  def set_team
    @team = Team.find(params[:id])
  end

  def authorize_owner!
    head :forbidden unless @team.owner == current_user
  end

  def team_params
    params.require(:team).permit(:name, :description)
  end
end
