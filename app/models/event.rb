require 'faye_client'
class Event < ActiveRecord::Base
  belongs_to :initiator, class_name: 'User'
  belongs_to :project
  belongs_to :target, polymorphic: true

  scope :by_member, -> (member_id) { where(initiator_id: member_id) }

  def push_to_project
    FayeClient.publish("/projects/#{self.project_id}", self.construct)
  end

  def push_to_target
    FayeClient.publish("/#{target_type.downcase.pluralize}/#{target_id}", self.construct)
  end

  def construct
    self.serializable_hash.merge(
            type: self.type,
            created_at: self.created_at.strftime('%H: %M'),
            target: self.target.serializable_hash,
            comment: self.try(:comment).try(:serializable_hash),
            initiator: self.initiator.serializable_hash)
  end
end
