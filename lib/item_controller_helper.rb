module ItemControllerHelper
  def redirect_or_render_update
    if @item.update(item_params_update)
      redirect_to item_path @item
    else
      render :edit
    end
  end

  def redirect_cant_blank
    redirect_back fallback_location: items_path
    flash[:alert] = "A quantidade não pode ser vazia!"
  end

  def redirect_show_cant_negative
    redirect_back fallback_location: items_path
    flash[:alert] = "A quantidade não pode ser negativa!"
  end

  def redirect_show_message(result)
    redirect_to item_path(@item) if result
    redirect_show_error_blank if params[:options].blank?
    redirect_back_show_not_negative if params[:options].to_i.negative?
    redirect_show_cant_zero if params[:options].to_i.zero?
  end

  def redirect_show_cant_zero
    redirect_back fallback_location: items_path
    flash[:alert] = "A quantidade não pode ser zero!"
  end

  def redirect_back_show_not_negative
    redirect_back fallback_location: items_path
    flash[:alert] = "Não é permitido quantidade negativa!"
  end

  def redirect_show_error_blank
    redirect_back fallback_location: items_path
    flash[:alert] = "Erro: campo em branco!"
  end

  private

  def item_params_update
    params.require(:item).permit(:name)
  end
end
