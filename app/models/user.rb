class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  has_many :teams, foreign_key: :owner_id, dependent: :destroy
  has_many :memberships, class_name: 'Member', foreign_key: :user_id, dependent: :destroy
end
