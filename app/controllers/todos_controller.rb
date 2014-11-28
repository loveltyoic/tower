class TodosController < ApplicationController
  ACTIONS = [:start, :pause, :finish, :destroy, :recover]
  protect_from_forgery only: :show
  before_action :find_self, except: :create
  before_action :check_access, except: :create

  def show
    respond_to do |format|
      format.html do 
        @project_id = params[:project_id]
        @subscribe_token = current_user.subscribe_token
        render 'show'
      end
      format.json do 
        render json: { events: @todo.events.map(&:construct), todo: @todo, assignee: @todo.assignee }
      end
    end
  end

  def create
    if current_user.accessable_project_ids.include?(params[:project_id].to_i)
      Todo.create! todo_params.merge(creator_id: current_user.id)
      render json: { status: 'success' }
    else
      render json: { status: 'error', message: '没有操作权限' }
    end
  end

  ACTIONS.each do |action|
    define_method action do
      action = action.to_s
      passive = (action.last == 'e' ? action + 'd' : action + 'ed')
      @todo.send "#{passive}_by", current_user.id
      render json: { status: 'success', action: action }
    end
  end

  def assign
    @todo.assigned_by(current_user.id, params[:to_id])
    render json: { status: 'success' }
  end

  def reassign
    @todo.reassigned_by(current_user.id, params[:to_id])
    render json: { status: 'success' }
  end

  def rename
    @todo.renamed_by(current_user.id, params[:new_name])
    render json: { status: 'success' }    
  end

  def reschedule
    @todo.rescheduled_by(current_user.id, params[:new_time])
    render json: { status: 'success' }    
  end

  private
  def find_self
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.permit(:name, :project_id, :assignee_id, :deadline)
  end

  def check_access
    render json: { status: 'error', message: '没有操作权限' } unless current_user.accessable_project_ids.include?(@todo.project_id)
  end
end
