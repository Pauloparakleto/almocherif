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
    return nil if !Time.now.workday?

    return nil if !Time.now.during_business_hours?

    return nil if @options.to_i.negative?

    return nil if @options.to_i.zero?

    sub = @item.quantity - @options.to_i
    return nil if sub.negative?

    @item.update(quantity: sub)

    @item
  end
end
