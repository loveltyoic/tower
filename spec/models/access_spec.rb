require 'rails_helper'

RSpec.describe Access, :type => :model do
  before :all do 
    seed_data
  end

  it "get accessable project ids" do 
    expect(@user_1.accessable_project_ids).to eq [@project.id]
    expect(@user_2.accessable_project_ids).to match_array [@project.id, @project_not_accesse_by_user_1.id]
  end
end
