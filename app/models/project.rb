class Project < ActiveRecord::Base
  has_many :users, through: :accesses
  has_many :accesses
  has_many :todos
  has_many :events
  belongs_to :team
end
