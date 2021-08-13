class LogsController < ApplicationController
  before_action :authenticate_user!
  def index
    @logs = Log.all
  end

  def show
    @log = Log.find(params[:id])
    @logs = Log.where(product_name: @log.product_name)
  end
end
