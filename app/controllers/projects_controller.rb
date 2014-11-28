class ProjectsController < ApplicationController
  def members
    render json: Project.find(params[:id]).users
  end
end
