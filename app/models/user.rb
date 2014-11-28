class User < ActiveRecord::Base
  has_many :memberships, foreign_key: :member_id
  has_many :teams, through: :memberships
  has_many :projects, through: :accesses
  has_many :accesses
  has_secure_password

  before_create :generate_subscribe_token
  def generate_subscribe_token
    begin
      self.subscribe_token = SecureRandom.hex
    end while self.class.exists?(subscribe_token: self.subscribe_token)
  end

  def accessable_project_ids
    projects.pluck(:id)
  end

  def finished_todos
    Todo.where(assignee_id: self.id, status: Todo.statuses[:finished])
  end
end
