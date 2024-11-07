class MembersController < ApplicationController
  before_action :set_team
  before_action :authorize_owner!, only: [:create, :destroy]

  def index
    @members = @team.members
    render json: @members
  end

  def create
    @member = @team.members.build(member_params)
    if @member.save
      render json: @member, status: :created
    else
      render json: @member.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @member = @team.members.find(params[:id])
    @member.destroy
    head :no_content
  end

  private

  def set_team
    @team = Team.find(params[:team_id])
  end

  def authorize_owner!
    head :forbidden unless @team.owner == current_user
  end

  def member_params
    params.require(:member).permit(:first_name, :last_name, :email, :user_id)
  end
end
