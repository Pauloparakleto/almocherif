class ItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    #@items = Item.all
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

    if @item.update(item_params_update)
      redirect_to item_path @item
    else
      render :edit
    end
  end

  def destroy
    @item = Item.find(params[:id])
    unless @item.audited?
      @item.destroy
      redirect_to items_path
      flash[:notice] = "Item deletado com sucesso!"
    else
      redirect_back fallback_location: items_path
      flash[:alert] = "Não pode deletar o item, pois já está com movimentação no registro!"
    end
  end

  def entry
    @item = Item.find(params[:id])
    result = StockRegister.new(item: @item, options: params[:options]).entry
    if result
      redirect_to item_path(@item)
    else
      redirect_back fallback_location: items_path
      flash[:alert] = "A quantidade não pode ser vazia nem negativa!"
    end
  end

  def exit
    @item = Item.find(params[:id])
    result = StockRegister.new(item: @item, options: params[:options]).exit
    if result
      redirect_to item_path(@item)
    elsif params[:options].blank?
      redirect_back fallback_location: items_path
      flash[:alert] = "Não se pode retirar items fora do horário comercial!"
    elsif params[:options].to_i.negative?
      redirect_back fallback_location: items_path
      flash[:alert] = "Não é permitido quantidade negativa!"
    else
      redirect_back fallback_location: items_path
      flash[:alert] = "Você está fora do horário comercial!"
    end
  end

  private

  def item_params
    params.require(:item).permit(:id, :name, :quantity)
  end

  def item_params_update
    params.require(:item).permit(:name)
  end
end
