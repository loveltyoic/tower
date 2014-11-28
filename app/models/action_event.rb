class ActionEvent < Event
  after_create :push_to_project, :push_to_target
end
