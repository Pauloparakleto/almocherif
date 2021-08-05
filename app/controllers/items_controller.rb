class ItemsController < ApplicationController
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
    if @item.destroy
      redirect_to items_path
    else
      redirect_back fallback_location: items_path
    end
  end

  def entry
    @item = Item.find(params[:id])
    StockRegister.new(item: @item, options: params[:options]).entry
    redirect_to item_path(@item)
  end

  def exit
    @item = Item.find(params[:id])
    StockRegister.new(item: @item, options: params[:options]).exit
    redirect_to item_path(@item)
  end

  private

  def item_params
    params.require(:item).permit(:id, :name, :quantity)
  end

  def item_params_update
    params.require(:item).permit(:name)
  end
end
