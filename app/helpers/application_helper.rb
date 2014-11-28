module ApplicationHelper
  def current_user
    User.find_by(id: session[:user])
  end

  def signin_user
    redirect_to '/sessions/new' unless current_user
  end

  def current_team
    session[:team] ? Team.find(session[:team]) : current_user.teams.first      
  end
end
