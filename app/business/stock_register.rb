# StockRegister updates the entry and exit of stock
# as well as creates a log with email user, product name
# and quantity movement
class StockRegister
  attr_reader :quantity
  def initialize(item: nil, options: nil)
    @item = item
    @options = options
    @quantity = options[:quantity]
    @user = options[:user]
  end
  def set_quantity
    quantity.to_i
  end

  def entry
    set_quantity
    return nil if set_quantity.negative?
    return nil if set_quantity.zero?

    sum = @item.quantity + set_quantity
    @item.update(quantity: sum)
    unless @item.audited?
      @item.update(audited: true)
    end
    create_log("entrada")
    @item
  end

  def exit

    return nil if !time_now.workday?

    return nil if !time_now.during_business_hours?

    return nil if set_quantity.negative?

    return nil if set_quantity.zero?

    sub = @item.quantity - set_quantity
    return nil if sub.negative?

    @item.update(quantity: sub)
    @item.update(audited: true)
    create_log("saída")
    @item
  end

  def create_log(type)
    Log.create(item_id: @item.id, product_name: @item.name, quantity: set_quantity, action: "#{type}", user_id: @user.id)
  end

  def time_now
    Time.now
  end
end
