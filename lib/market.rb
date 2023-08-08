class Market
  attr_reader :name,
              :vendors,
              :date

  def initialize(name)
    @name = name
    @vendors = []
    @date = date_format
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map(&:name)
  end

  def vendors_that_sell(item)
    @vendors.select { |vendor| vendor.inventory.include?(item) }
  end

  def total_inventory
    inventory = Hash.new { |hash, key| hash[key] = { quantity: 0, vendors: [] } }

    @vendors.each do |vendor|
      vendor.inventory.each do |item, quantity|
        inventory[item][:quantity] += quantity
        inventory[item][:vendors] << vendor
      end
    end

    inventory
  end

  def overstocked_items
    overstocked_items = []

    @vendors.each do |vendor|
      vendor.inventory.each do |item, quantity|
        if quantity > 50 && vendors_that_sell(item).length > 1
          overstocked_items << item
        end
      end
    end
  
    overstocked_items
  end

  def sorted_item_list
    all_item_names = []
  
    @vendors.each do |vendor|
      inventory_hash = vendor.inventory
  
      inventory_hash.each do |item, _quantity|
        item_name = item.name
        all_item_names << item_name
      end
    end
  
    unique_item_names = all_item_names.uniq
    sorted_item_names = unique_item_names.sort
    sorted_item_names
  end

  def date_format
    current_date = Date.today
    formatted_date = current_date.strftime('%d/%m/%Y')

    formatted_date
  end
end