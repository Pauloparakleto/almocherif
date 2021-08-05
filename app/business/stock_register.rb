class StockRegister
  def initialize(item: nil, options: nil)
    @item = item
    @options = options
  end

  def entry
    sum = @item.quantity + @options.to_i
    @item.update(quantity: sum)
    @item
  end

  def exit
    sub = @item.quantity - @options.to_i
    @item.update(quantity: sub)
    @item
  end
end
