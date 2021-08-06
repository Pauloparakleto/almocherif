class LogsController < ApplicationController
  before_action :authenticate_user!
  def index
    @logs = Log.all
  end
end
