require 'rails_helper'

RSpec.describe EventsController, :type => :controller do
  before :all do 
    seed_data
  end

  context "user 1" do 
    before :each do 
      login(@user_1)
    end
    it "get events" do 
      get :index, format: :json, team_id: @team.id
      expect(assigns(:project_ids)).to eq [@project.id]
      expect(assigns(:events)).to eq @project.events
    end
  end

  context "user 2" do 
    before :each do 
      login(@user_2)
    end
    it "get events" do 
      get :index, format: :json, team_id: @team.id
      expect(assigns(:project_ids)).to eq [@project.id, @project_not_accesse_by_user_1.id]
      expect(assigns(:events)).to match_array (@project.events + @project_not_accesse_by_user_1.events)
    end
  end

  context "not signed yet" do 
    it "should redirect" do 
      get :index, team_id: @team.id
      expect(response).to redirect_to '/sessions/new'
    end
  end
end
