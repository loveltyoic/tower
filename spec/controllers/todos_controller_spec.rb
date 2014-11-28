require 'rails_helper'

RSpec.describe TodosController, :type => :controller do
  before :all do 
    seed_data
  end

  before :each do 
    login(@user_1)
  end

  context "have access" do 
    it "show" do 
      get :show, id: @todo.id, project_id: @project.id
      expect(response).to render_template :show
    end

    it "create" do 
      expect{
        post :create, project_id: @project.id, name: 'test'
      }.to change(Todo, :count).by(1)
      expect(JSON.parse(response.body)['status']).to eq 'success'
    end

    it "act" do 
      [:start, :pause, :reschedule, :assign, :finish, :destroy, :recover, :reassign, :rename].each do |action|
        expect{
          post action, id: @todo.id, project_id: @project.id, to_id: @user_2.id, new_time: Time.now, new_name: 'another_test'
        }.to change(Event, :count).by(1)
        expect(ActionEvent.last.action_type).to eq action.to_s
      end
    end
  end

  context "have not access" do 
    it "show" do 
      get :show, id: @todo_not_access_by_user_1, project_id: @project_not_accesse_by_user_1
      expect(JSON.parse(response.body)["status"]).to eq 'error'
    end
  end

end
