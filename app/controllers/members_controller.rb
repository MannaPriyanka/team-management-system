class MembersController < ApplicationController
  before_action :set_team
  before_action :authorize_owner!, only: [:create, :destroy]

  def index
    @members = @team.members
    @members = @members.where("last_name ILIKE ?", "%#{params[:last_name]}%") if params[:last_name].present?
    @members = @members.page(params[:page] || 1).per(params[:per_page] || 10)
    render json: @members, status: :ok
  end

  def create
    @member = @team.members.build(member_params)
    if @member.save
      render json: { member: @member, message: 'Member added successfully' }, status: :created
    else
      render json: { errors: @member.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @member = @team.members.find_by(id: params[:id])
    if @member
      @member.destroy
      render json: { message: 'Member removed successfully' }, status: :no_content
    else
      render json: { error: 'Member not found' }, status: :not_found
    end
  end

  private

  def set_team
    @team = Team.find_by(id: params[:team_id])
    render json: { error: 'Team not found' }, status: :not_found unless @team
  end

  def authorize_owner!
    render json: { error: 'Forbidden' }, status: :forbidden unless @team.owner == current_user
  end

  def member_params
    params.require(:member).permit(:first_name, :last_name, :email, :user_id)
  end
end
