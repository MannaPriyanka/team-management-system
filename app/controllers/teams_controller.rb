class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: [:show, :update, :destroy]
  before_action :authorize_owner!, only: [:update, :destroy]

  def index
    @teams = current_user.teams.page(params[:page] || 1).per(params[:per_page] || 10)
    render json: @teams, status: :ok
  end

  def create
    @team = current_user.teams.build(team_params)
    if @team.save
      render json: { team: @team, message: 'Team created successfully' }, status: :created
    else
      render json: { errors: @team.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: @team, status: :ok
  end

  def update
    if @team.update(team_params)
      render json: { team: @team, message: 'Team updated successfully' }, status: :ok
    else
      render json: { errors: @team.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @team.destroy
    render json: { message: 'Team deleted successfully' }, status: :no_content
  end

  private

  def set_team
    @team = Team.find_by(id: params[:id])
    render json: { error: 'Team not found' }, status: :not_found unless @team
  end

  def authorize_owner!
    render json: { error: 'Forbidden' }, status: :forbidden unless @team.owner == current_user
  end

  def team_params
    params.require(:team).permit(:name, :description)
  end
end
