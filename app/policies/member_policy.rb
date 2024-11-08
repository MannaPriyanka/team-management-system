# app/policies/member_policy.rb
class MemberPolicy < ApplicationPolicy
  def index?
    user == record.team.owner || record.team.members.include?(user)
  end

  def create?
    user == record.team.owner
  end

  def destroy?
    user == record.team.owner
  end
end
