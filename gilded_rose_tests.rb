require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require "./gilded_rose"

class ItemsTest < Minitest::Test
  def setup

    @items = []
    @items << Item.new("+5 Dexterity Vest", 5, 18)
    @items << Item.new("Aged Brie", 3, 0)
    @items << Item.new("Elixir of the Mongoose", 3, 5)
    @items << Item.new("Sulfuras, Hand of Ragnaros", 0, 55)
    @items << Item.new("Backstage passes to a TAFKAL80ETC concert", 19, 30)
    @items << Item.new("Conjured Mana Cake", 1, 11)

    @rose = GildedRose.new(@items)
    @items = @rose.instance_variable_get(:@items)

  end

  attr_reader :rose, :items

  def test_after_1_day
    rose.update_quality
    check_items([4, 17], [2, 1], [2, 4], [0, 55], [18, 31], [0, 9])
  end

  def test_after_5_days
    5.times { rose.update_quality }
    check_items([0, 13], [-2, 7], [-2, 0], [0, 55], [14, 35], [-4, 0])
  end


  def test_after_10_days
    10.times { rose.update_quality }
    check_items([0, 8], [-7, 17], [-7, 0], [0, 55], [9, 40], [-9, 0])
  end

  private

  def check_items(*expected_items)
    expected_items.zip(items) do |(sell_in, quality), item|
      assert_equal(sell_in, item.sell_in, "#{item.name} sell_in")
      assert_equal(quality, item.quality, "#{item.name} quality")
    end
  end
end