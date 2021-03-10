require 'delegate'

class GildedRose
  attr_accessor :items

  def initialize(items)
    @items = items
  end

  def update_item_quality
    items.each do |item|
      ItemWrapper.wrap(item).update
    end
  end

end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end

class AgedBrie < ItemWrapper
  def quality_adjustment_amount
    adjustment = 1
    if sell_in < 0
      adjustment += 1
    end

    adjustment
  end
end

class BackstagePass < ItemWrapper
  def quality_adjustment_amount
    adjustment = 1
    if sell_in < 11
      adjustment += 1
    end
    if sell_in < 6
      adjustment += 1
    end
    if sell_in < 0
      adjustment -= quality
    end

    adjustment
  end
end

def quality=(new_quality)
    new_quality = 0 if new_quality < 0
    new_quality = 50 if new_quality > 50
    super(new_quality)
end

class ConjuredManaCake < ItemWrapper
  def quality_adjustment_amount
    adjustment = -2
    if sell_in < 0
      adjustment -= 2
    end

    adjustment
  end
end

class SulfurasHandofRagnaros < ItemWrapper
  def quality_adjustment_amount
  end
end

class ItemWrapper < SimpleDelegator
  def self.wrap(item)

    case item.name
    when "Aged Brie"
      AgedBrie.new(item)
    when "Backstage passes to a TAFKAL80ETC concert"
      BackstagePass.new(item)
    when "Conjured Mana Cake"
      ConjuredManaCake.new(item)
    when "Sulfuras, Hand of Ragnaros"
      SulfurasHandofRagnaros.new(item)
    else
      new(item)
    end

  end

  def update
    return if name == "Sulfuras, Hand of Ragnaros"

    age
    update_item_quality

  end

  def age
    self.sell_in -= 1
  end

  def update_item_quality
    self.quality += quality_adjustment_amount
  end

  def quality_adjustment_amount
    adjustment = 0

    if sell_in < 0
      adjustment -= 1
    else
      adjustment -= 1
    end

    adjustment

  end

end

