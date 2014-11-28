# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
[User, Project, Team, Todo, Event, Comment].each(&:destroy_all)
user_1 = FactoryGirl.create(:user, name: '鸣人', email: 'tower1@gmail.com', password: '123456')
user_2 = FactoryGirl.create(:user, name: '佐助', email: 'tower2@gmail.com', password: '123456')
team = FactoryGirl.create(:team)
project = FactoryGirl.create(:project)
team.projects << project
10.times do 
  todo = FactoryGirl.create(:todo, creator_id: user_1.id, project_id: project.id)
end

[user_1, user_2].each do |user|
  team.members << user
  project.users << user
end
