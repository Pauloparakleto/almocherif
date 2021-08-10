class StockRegister
  def initialize(item: nil, options: nil)
    @item = item
    @options = options
    @quantity = options[:quantity]
    @user = options[:user]
  end

  def entry
    return nil if @quantity.to_i.negative?
    return nil if @quantity.to_i.zero?

    sum = @item.quantity + @quantity.to_i
    @item.update(quantity: sum)
    unless @item.audited?
      @item.update(audited: true)
    end
    Log.create(item_id: @item.id, product_name: @item.name, quantity: @quantity.to_i, action: "entrada", user_id: @user.id)
    @item
  end

  def exit
    return nil if !Time.now.workday?

    return nil if !Time.now.during_business_hours?

    return nil if @quantity.to_i.negative?

    return nil if @quantity.to_i.zero?

    sub = @item.quantity - @quantity.to_i
    return nil if sub.negative?

    @item.update(quantity: sub)
    @item.update(audited: true)
    Log.create(item_id: @item.id, product_name: @item.name, quantity: @quantity.to_i, action: "saída", user_id: @user.id)
    @item
  end
end
