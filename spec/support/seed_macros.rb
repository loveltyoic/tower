module SeedMacros
  def seed_data
    @user_1 = create(:user, name: '鸣人', email: 'tower1@gmail.com', password: '123456')
    @user_2 = create(:user, name: '佐助', email: 'tower2@gmail.com', password: '123456')
    @team = create(:team)
    @project = create(:project)
    @project_not_accesse_by_user_1 = create(:project)
    @team.projects << @project
    @team.projects << @project_not_accesse_by_user_1

    @todo = create(:todo, creator_id: @user_1.id, project_id: @project.id)

    [@user_1, @user_2].each do |user|
      @team.members << user
      @project.users << user
    end
    @project_not_accesse_by_user_1.users << @user_2
    @todo_not_access_by_user_1 = create(:todo, creator_id: @user_2.id, project_id: @project_not_accesse_by_user_1.id)
  end

  def login(user)
    session[:user] = user.id
  end
end