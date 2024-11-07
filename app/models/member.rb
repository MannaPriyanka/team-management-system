class Member < ApplicationRecord
  belongs_to :team
  belongs_to :user

  validates :first_name, :last_name, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
end
