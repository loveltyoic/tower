class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :comment_event, primary_key: :event_id
end
