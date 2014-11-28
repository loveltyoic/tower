require 'rails_helper'

RSpec.describe Todo, :type => :model do
  before :all do 
    seed_data
  end

  it "assigned by user_1 to user_1" do 
    @todo.assigned_by(@user_1.id, @user_2.id)
    expect(@todo.assignee).to eq @user_2
  end

  it "started by user_1" do 
    @todo.started_by(@user_1.id)
    expect(@todo.ongoing?).to eq true
    expect(@todo.assignee).to eq @user_1
  end

  it "reassigned by user_1 to user_2" do 
    @todo.reassigned_by(@user_1.id, @user_2.id)
    expect(@todo.assignee).to eq @user_2
  end

  it "paused by user_1" do 
    @todo.paused_by(@user_1.id)
    expect(@todo.pending?).to eq true
  end

  it "destroyed by user_1" do 
    @todo.destroyed_by(@user_1.id)
    expect(@todo.deleted?).to eq true
  end

  it "finished by user_1" do 
    @todo.finished_by(@user_1.id)
    expect(@todo.finished?).to eq true
    expect(@user_1.finished_todos).to include(@todo)
  end

  it "rescheduled by user_1" do 
    time = Time.now
    @todo.rescheduled_by(@user_1.id, time)
    expect(@todo.deadline).to eq time.to_date
  end

  it "renamed by user_1" do 
    @todo.renamed_by(@user_1.id, "进击的巨人")
    expect(@todo.name).to eq "进击的巨人"
  end

  it "recovered by user_1" do 
    @todo.recovered_by(@user_1.id)
    expect(@todo.ongoing?).to eq true
  end

  it "commented by user_1" do 
    @todo.commented_by(@user_1.id, "为什么还不更新")
    expect(@todo.comments.last.content).to eq "为什么还不更新"
  end
end
