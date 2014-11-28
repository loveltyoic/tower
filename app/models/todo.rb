class Todo < ActiveRecord::Base
  belongs_to :project
  belongs_to :assignee, class_name: 'User'
  belongs_to :creator, class_name: 'User' 
  has_many :comments, as: :commentable
  has_many :events, as: :target

  enum status: [:pending, :ongoing, :finished, :deleted]

  after_create :created_by
  def created_by
    action = (self.assignee_id ? "给#{assignee.name}" : "") + "创建了任务"
    trigger_action_event(action, self.creator_id, 'create')
  end

  def assigned_by(by, to)
    trigger_action_event("给 #{User.find(to).name} 指派了任务", by, 'assign') { self.update(assignee_id: to) }
  end

  def reassigned_by(by, to)
    if self.assignee
      trigger_action_event("把 #{self.assignee.name} 的任务指派给 #{User.find(to).name}", by, 'reassign') { self.update(assignee_id: to) }
    else
      assigned_by(by, to)
    end
  end

  def rescheduled_by(by, time)
    trigger_action_event("将任务完成时间从 #{deadline.try(:to_date) || '没有截止日期'} 修改为 #{time.try(:to_date) || '没有截止日期'}", by, 'reschedule') { self.update(deadline: time) }
  end

  def destroyed_by(by)
    trigger_action_event("删除了任务", by, 'destroy') { self.deleted! }
  end

  def finished_by(by)
    trigger_action_event("完成了任务", by, 'finish') do 
      self.finished!
      self.update(assignee_id: by)
    end
  end

  def started_by(by)
    trigger_action_event("开始处理这条任务", by, 'start') do 
      self.ongoing!
      self.update(assignee_id: by)
    end
  end

  def paused_by(by)
    trigger_action_event("暂停处理这条任务", by, 'pause') { self.pending! }
  end

  def renamed_by(by, new_name)
    trigger_action_event("将任务 #{self.name} 修改为 #{new_name}", by, 'rename') { self.update(name: new_name) }
  end

  def recovered_by(by)
    trigger_action_event("恢复了任务", by, 'recover') { self.ongoing! }
  end

  def commented_by(by, content)
    CommentEvent.trigger(
      action: "回复了任务",
      initiator_id: by,
      target_id: self.id,
      target_type: self.class.to_s,
      project_id: self.project_id,
      content: content
    )   
  end

  private
  def trigger_action_event(action, by, type)
    ActionEvent.create(
      action: action, 
      initiator_id: by, 
      target_id: self.id,
      target_type: self.class.to_s,
      project_id: self.project_id,
      action_type: type)
    yield if block_given?
  end

end
