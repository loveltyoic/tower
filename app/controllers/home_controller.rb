class HomeController < ApplicationController
  def index
    if current_user
      redirect_to "/teams/#{current_user.teams.first.id}/events"
    else
      redirect_to '/sessions/new'
    end
  end
end