class MembersController < ApplicationController
  def index
    @members = Team.find(params[:team_id]).members
    respond_to do |format|
      format.json do 
        render json: @members
      end
    end
  end
end
