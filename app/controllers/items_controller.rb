require "item_controller_helper"
class ItemsController < ApplicationController
  include ItemControllerHelper
  before_action :authenticate_user!
  before_action :set_current_user, only: [:entry, :exit]

  def index
    # @items = Item.all
    @q = Item.ransack(params[:q])
    @items = @q.result(distinct: true).page params[:page]
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.create(item_params)
    redirect_or_render
  end

  def redirect_or_render
    if @item.valid?
      redirect_to @item
    else
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])

    redirect_or_render_update
  end

  def destroy
    @item = Item.find(params[:id])
    redirect_on_destroy
  end

  def redirect_on_destroy
    if @item.audited?
      canto_destroy_message
    else
      destroyed_sucessfull_message
    end
  end

  def destroyed_sucessfull_message
    @item.destroy
    redirect_to items_path
    flash[:notice] = "Item deletado com sucesso!"
  end

  def canto_destroy_message
    redirect_back fallback_location: items_path
    flash[:alert] = "Não pode deletar o item, pois já está com movimentação no registro!"
  end

  def entry
    @item = Item.find(params[:id])
    result = StockRegister.new(item: @item, options: { quantity: params[:options], user: @user }).entry
    redirect_on_entry(result)
  end

  def exit
    @item = Item.find(params[:id])
    result = StockRegister.new(item: @item, options: { quantity: params[:options], user: @user }).exit
    redirect_show_message(result)
  end

  private

  def set_current_user
    @user = User.find(current_user[:id])
  end

  def item_params
    params.require(:item).permit(:id, :name, :quantity)
  end
end
