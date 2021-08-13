class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user, only: [:entry, :exit]

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
    result = StockRegister.new(item: @item, options: { quantity: params[:options], user: @user }).entry
    unless result.errors.any?
      flash[:notice] = "Quantidade acrescida com sucesso!"
      redirect_to item_path(@item)
    else
      flash[:alert] = result.errors.full_messages.first
      redirect_back fallback_location: items_path
    end
  end

  def exit
    @item = Item.find(params[:id])
    result = StockRegister.new(item: @item, options: { quantity: params[:options], user: @user }).exit
    unless result.errors.any?
      flash[:notice] = "Quantidade retidada com sucesso!"
      redirect_to item_path(@item)
    else
      flash[:alert] = result.errors.full_messages.first
      redirect_back fallback_location: items_path
    end
  end

=begin
    elsif params[:options].blank?
      redirect_back fallback_location: items_path
      flash[:alert] = "Erro: campo em branco!"
    elsif params[:options].to_i.negative?
      redirect_back fallback_location: items_path
      flash[:alert] = "Não é permitido quantidade negativa!"
    elsif params[:options].to_i.zero?
      redirect_back fallback_location: items_path
      flash[:alert] = "A quantidade não pode ser zero!"
    else
      redirect_back fallback_location: items_path
      flash[:alert] = "Você está fora do horário comercial!"
     end
=end

  private

  def set_current_user

    @user = User.find(current_user[:id])
  end

  def item_params
    params.require(:item).permit(:id, :name, :quantity)
  end

  def item_params_update
    params.require(:item).permit(:name)
  end
end
