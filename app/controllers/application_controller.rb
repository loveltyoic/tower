class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery with: :null_session
  before_action :signin_user
end
