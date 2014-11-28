require 'rails_helper'

RSpec.describe SessionsController, :type => :controller do

  describe "login" do
    it "success" do
      get :login
      expect(response).to render_template :new
    end
  end

end
