class CommentsController < ApplicationController
  protect_from_forgery except: :create
  before_action :find_parent
  def create
    @parent.commented_by(current_user.id, params[:content])
    render json: { status: 'success' }
  end

  private
  def find_parent
    @parent = Todo.find(params[:todo_id]) if params[:todo_id]
  end
end
