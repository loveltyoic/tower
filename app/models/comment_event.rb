class CommentEvent < Event
  has_one :comment, foreign_key: :event_id

  class << self
    def trigger(params)
      content = params.extract!(:content)[:content]
      event = create(params)
      event.target.comments.create(content: content, event_id: event.id)
      event.push_to_project
      event.push_to_target
    end
  end
end