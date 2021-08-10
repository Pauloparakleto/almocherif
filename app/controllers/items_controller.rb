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
    if @item.audited?
      redirect_back fallback_location: items_path
      flash[:alert] = "Não pode deletar o item, pois já está com movimentação no registro!"
    else
      @item.destroy
      redirect_to items_path
      flash[:notice] = "Item deletado com sucesso!"
    end
  end

  def entry
    @item = Item.find(params[:id])
    result = StockRegister.new(item: @item, options: { quantity: params[:options], user: @user }).entry
    if result
      redirect_to item_path(@item)
    elsif params[:options].blank?
      redirect_cant_blank
    elsif params[:options].to_i.zero?
      redirect_show_cant_zero
    else
      redirect_show_cant_negative
    end
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
