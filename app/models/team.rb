class Team < ActiveRecord::Base
  has_many :members, through: :memberships, class_name: 'User'
  has_many :memberships
  has_many :projects
end
