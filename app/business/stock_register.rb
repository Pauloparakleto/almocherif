# StockRegister updates the entry and exit of stock
# as well as creates a log with email user, product name
# and quantity movement
class StockRegister
  attr_reader :quantity
  attr_reader :time_now
  def initialize(item: nil, options: nil)
    @item = item
    @time_now = StockRegisterSupport.time_now
    @quantity = options[:quantity]
    @user = options[:user]
  end
  def set_quantity
    quantity.to_i
  end

  def entry
    set_quantity
    return nil if set_quantity.negative? || set_quantity.zero?

    sum = @item.quantity + set_quantity
    update_stock_on_entry(sum)
  end

  def update_stock_on_entry(sum)
    @item.update(quantity: sum)
    unless @item.audited?
      @item.update(audited: true)
    end
    create_log("entrada")
    @item
  end

  def exit

    return nil if check_business_time

    sub = @item.quantity - set_quantity
    update_stock_exit(sub)
  end

  def update_stock_exit(sub)
    @item.update(quantity: sub)
    @item.update(audited: true)
    create_log("saída")
    @item
  end

  def check_business_time
    !time_now.workday? || !time_now.during_business_hours? || set_quantity.negative? || set_quantity.zero?
  end

  def create_log(type)
    Log.create(item_id: @item.id, product_name: @item.name, quantity: set_quantity, action: "#{type}", user_id: @user.id)
  end
end
