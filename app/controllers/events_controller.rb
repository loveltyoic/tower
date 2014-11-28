class EventsController < ApplicationController
  def index
    # 取用户所属项目和当前小组项目的交集
    @project_ids = current_user.accesses.map(&:project_id) & Project.where(team_id: params[:team_id]).pluck(:id)

    respond_to do |format|
      format.json do 
        @events = Event.includes(:target, :initiator)
          .where(project_id: @project_ids)
          .order('created_at desc')
          .page(params[:page]||1).per(50)

        render json: @events.map(&:construct)
      end
      format.html do 
        @subscribe_token = current_user.subscribe_token
        render 'index'
      end
    end
  end
end
