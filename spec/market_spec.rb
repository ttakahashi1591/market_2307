require './lib/item'
require './lib/vendor'
require './lib/market'
require 'date'

RSpec.describe Market do
  before(:each) do 
    @market = Market.new("South Pearl Street Farmers Market")
    @vendor1 = Vendor.new("Rocky Mountain Fresh")
    @vendor2 = Vendor.new("Ba-Nom-a-Nom")
    @vendor3 = Vendor.new("Palisade Peach Shack")
    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    @item2 = Item.new({name: 'Tomato', price: "$0.50"})
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
  end

  describe "#initialize" do
    it "exists and has readable attributes" do
      expect(@market).to be_a(Market)
      expect(@market.name).to eq("South Pearl Street Farmers Market")
      expect(@market.vendors).to eq([])
      expect(@market.date).to eq("08/08/2023")
    end
  end

  describe "#add_vendor" do
    it "adds a vendor to the market" do
      @vendor1.stock(@item1, 35)
      @vendor1.stock(@item2, 7)
      @vendor2.stock(@item4, 50)
      @vendor2.stock(@item3, 25)
      @vendor3.stock(@item1, 65)
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.vendors).to eq([ @vendor1, @vendor2, @vendor3 ])
    end
  end

  describe "#vendor_names" do
    it "add the name of vendors to an empty array" do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.vendor_names).to eq([ "Rocky Mountain Fresh", "Ba-Nom-a-Nom", "Palisade Peach Shack" ])
    end
  end

  describe "#vendors_that_sell" do
    it "provides a list of vendors that sell in an array" do
      @vendor1.stock(@item1, 35)
      @vendor1.stock(@item2, 7)
      @vendor2.stock(@item4, 50)
      @vendor2.stock(@item3, 25)
      @vendor3.stock(@item1, 65)
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.vendors_that_sell(@item1)).to eq([ @vendor1, @vendor3 ])
      expect(@market.vendors_that_sell(@item4)).to eq([ @vendor2 ])
      expect(@vendor1.potential_revenue).to eq(29.75)
      expect(@vendor2.potential_revenue).to eq(345.00)
      expect(@vendor3.potential_revenue).to eq(48.75)
    end
  end

  describe "#total_inventory" do
    it "reports the quatities of all items sold at the market in a hash" do
      @vendor1.stock(@item1, 35)
      @vendor1.stock(@item2, 7)
      @vendor2.stock(@item4, 50)
      @vendor2.stock(@item3, 25)
      @vendor3.stock(@item1, 65)
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expected = {
        @item1 => { quantity: 100, vendors: [@vendor1, @vendor3] },
        @item2 => { quantity: 7, vendors: [@vendor1] },
        @item3 => { quantity: 25, vendors: [@vendor2] },
        @item4 => { quantity: 50, vendors: [@vendor2] }
          }
      expect(@market.total_inventory).to eq(expected)
    end
  end

  describe "#overstocked_items" do
    it "returns an array of items that are overstocked" do
      @vendor1.stock(@item1, 35)
      @vendor1.stock(@item2, 7)
      @vendor2.stock(@item4, 50)
      @vendor2.stock(@item3, 25)
      @vendor3.stock(@item1, 65)
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      overstocked_items = @market.overstocked_items

      expect(overstocked_items).to include(@item1)
      expect(overstocked_items).not_to include(@item2, @item3, @item4)
    end
  end

  describe "#sorted_item_list" do
    it "returns an array of items that are overstocked" do
      @vendor1.stock(@item1, 35)
      @vendor1.stock(@item2, 7)
      @vendor2.stock(@item4, 50)
      @vendor2.stock(@item3, 25)
      @vendor3.stock(@item1, 65)
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expected = ['Banana Nice Cream', 'Peach', 'Peach-Raspberry Nice Cream', 'Tomato']

      expect(@market.sorted_item_list).to eq(expected)
    end
  end

  describe "#date_format" do
    it "assigns the date as a string for market created today" do
      expect(@market.date_format).to eq("08/08/2023")
    end

    it "assigns the date as a string for a market created in the past" do
      past_date = Date.new(2023, 8, 7)
      allow(Date).to receive(:today).and_return(past_date)

      market = Market.new("Market Name")
      expect(@market.date_format).to eq("07/08/2023")
    end

    it "assigns the date as a string for a market created in the future" do
      past_date = Date.new(2023, 8, 9)
      allow(Date).to receive(:today).and_return(past_date)

      market = Market.new("Market Name")
      expect(@market.date_format).to eq("09/08/2023")
    end
  end
end