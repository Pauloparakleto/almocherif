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
    unless @item.audited?
      @item.update(audited: true)
    end
    Log.create(item_id: @item.id, product_name: @item.name, quantity: @options.to_i)
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
    @item.update(audited: true)
    Log.create(item_id: @item.id, product_name: @item.name, quantity: @options.to_i)
    @item
  end
end
