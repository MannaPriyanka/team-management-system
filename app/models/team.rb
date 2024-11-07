class Team < ApplicationRecord
  belongs_to :owner, class_name: 'User'  # Assumes User model is used for authentication
  has_many :members, dependent: :destroy

  validates :name, presence: true
end
