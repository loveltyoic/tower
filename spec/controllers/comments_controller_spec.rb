require 'rails_helper'

RSpec.describe CommentsController, :type => :controller do

  before :all do 
    seed_data
  end

  before :each do 
    login(@user_1)
  end

  it "comment todo" do 
    expect{
      post :create, todo_id: @todo.id, project_id: @project.id, content: '火影已完结'
    }.to change(CommentEvent, :count).by(1)
    expect(CommentEvent.last.comment.content).to eq '火影已完结'
  end

end
