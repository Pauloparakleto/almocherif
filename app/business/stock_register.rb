# StockRegister updates the entry and exit of stock
# as well as creates a log with email user, product name
# and quantity movement
class StockRegister
  attr_reader :quantity
  attr_reader :time_now

  def initialize(item: nil, options: nil)
    @item = item
    @time_now = Time.now
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
    check_business_time
    return @item if @item.errors.any?

    check_quantity(set_quantity)
    return @item if @item.errors.any?

    sub = @item.quantity - set_quantity
    update_stock_exit(sub)
  end

  def check_quantity(quantity)
    if quantity.negative?
      @item.errors.add :base, "A quantidade não pode ser negativa!"
      @item
    end
    if quantity.zero?
      @item.errors.add :base, "A quantidade não pode ser zero!"
      @item
    end
  end

  def update_stock_exit(sub)
    @item.update(quantity: sub)
    if @item.update(quantity: sub)
      @item.update(audited: true)
      create_log("saída")
    end
    @item
  end

  def check_business_time
    unless Date.today.workday?
      @item.errors.add :base, "Você está fora do dia de trabalho!"
      @item
    end
    unless time_now.during_business_hours?
      @item.errors.add :base, "Você está fora da hora de trabalho!"
      @item
    end
    @item
  end

  def create_log(type)
    Log.create(item_id: @item.id, product_name: @item.name, quantity: set_quantity, action: "#{type}", user_id: @user.id)
  end
end
