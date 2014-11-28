class SessionsController < ApplicationController
  skip_before_action :signin_user
  def login
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user] = user.id
      redirect_to "/teams/#{user.teams.first.id}/events"
    else
      render :new
    end
  end

  def new
  end
end
