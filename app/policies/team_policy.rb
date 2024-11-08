# app/policies/team_policy.rb
class TeamPolicy < ApplicationPolicy
  def update?
    user == record.owner
  end

  def destroy?
    user == record.owner
  end

  def show?
    user == record.owner || record.members.include?(user) # if members can view the team
  end

  def index?
    true # assuming any authenticated user can list their teams
  end
end
