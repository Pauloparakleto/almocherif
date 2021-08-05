class StockRegister
  def initialize(item: nil, options: nil)
    @item = item
    @options = options
  end

  def entry
    return nil if @options.to_i.negative?
    return nil if @options.to_i.zero?

    sum = @item.quantity + @options.to_i
    @item.update(quantity: sum)
    @item
  end

  def exit
    return nil if @options.to_i.negative?
    return nil if @options.to_i.zero?

    sub = @item.quantity - @options.to_i
    @item.update(quantity: sub)
    return nil if sub.negative?

    @item
  end
end
