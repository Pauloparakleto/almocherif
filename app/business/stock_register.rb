class StockRegister
  def initialize(item: nil, options: nil)
    @item = item
    @options = options
    @quantity = options[:quantity]
    @user = options[:user]
  end

  def check_audited
    return if @item.audited?

    @item.update(audited: true)
  end

  def entry
    return nil if quantity_negative?
    return nil if quantity_zero?

    check_audited
    create_log
    update_quantity_entry
  end

  def update_quantity_entry
    sum = @item.quantity + @quantity.to_i
    @item.update(quantity: sum)
    @item
  end

  def create_log
    Log.create(item_id: @item.id, product_name: @item.name, quantity: @quantity.to_i, action: "entrada",
               user_id: @user.id)
  end

  def exit
    return nil unless workday? && business_time?

    return nil if quantity_negative? || quantity_zero?

    sub = @item.quantity - @quantity.to_i
    return nil if sub.negative?

    update_stock_and_create_log(sub)
  end

  def update_stock_and_create_log(sub)
    update_stock(sub)
    create_log_exit
  end

  def quantity_zero?
    @quantity.to_i.zero?
  end

  def quantity_negative?
    @quantity.to_i.negative?
  end

  def business_time?
    Time.zone.now.during_business_hours?
  end

  def workday?
    Time.zone.now.workday?
  end

  def update_stock(sub)
    @item.update(quantity: sub)
    @item.update(audited: true)
  end

  def create_log_exit
    Log.create(item_id: @item.id, product_name: @item.name, quantity: @quantity.to_i, action: "saída",
               user_id: @user.id)
    @item
  end
end
