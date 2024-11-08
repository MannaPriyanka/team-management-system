class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: [:show, :update, :destroy]

  def index
    @teams = current_user.teams.page(params[:page] || 1).per(params[:per_page] || 10)
    authorize @teams  # Authorize access to the index action
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
    authorize @team  # Check if the user is authorized to view this team
    render json: @team, status: :ok
  end

  def update
    authorize @team  # Check if the user is authorized to update this team
    if @team.update(team_params)
      render json: { team: @team, message: 'Team updated successfully' }, status: :ok
    else
      render json: { errors: @team.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @team  # Check if the user is authorized to destroy this team
    @team.destroy
    render json: { message: 'Team deleted successfully' }, status: :no_content
  end

  private

  def set_team
    @team = Team.find_by(id: params[:id])
    render json: { error: 'Team not found' }, status: :not_found unless @team
  end

  def team_params
    params.require(:team).permit(:name, :description)
  end
end
