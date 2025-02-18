require 'rspec/given'
require 'gilded_rose'

describe "#update_quality" do

  context "with a single" do
    Given(:initial_sell_in) { 5 }
    Given(:initial_quality) { 10 }
    Given(:item) { Item.new(name, initial_sell_in, initial_quality) }

    When { update_quality([item]) }

    context "normal item" do
      Given(:name) { "NORMAL ITEM" }

      Invariant { expect(item.sell_in).to eq initial_sell_in-1 }

      context "before sell date" do
        Then { expect(item.quality).to eq initial_quality-1 }
      end

      context "on sell date" do
        Given(:initial_sell_in) { 0 }
        Then { expect(item.quality).to eq initial_quality-2 }
      end

      context "after sell date" do
        Given(:initial_sell_in) { -10 }
        Then { expect(item.quality).to eq initial_quality-2 }
      end

      context "of zero quality" do
        Given(:initial_quality) { 0 }
        Then { expect(item.quality).to eq 0 }
      end
    end

    context "Aged Brie" do
      Given(:name) { "Aged Brie" }

      Invariant { expect(item.sell_in).to eq initial_sell_in-1 }

      context "before sell date" do
        Then { expect(item.quality).to eq initial_quality+1 }

        context "with max quality" do
          Given(:initial_quality) { 50 }
          Then { expect(item.quality).to eq initial_quality }
        end
      end

      context "on sell date" do
        Given(:initial_sell_in) { 0 }
        Then { expect(item.quality).to eq initial_quality+2 }

        context "near max quality" do
          Given(:initial_quality) { 49 }
          Then { expect(item.quality).to eq 50 }
        end

        context "with max quality" do
          Given(:initial_quality) { 50 }
          Then { expect(item.quality).to eq initial_quality }
        end
      end

      context "after sell date" do
        Given(:initial_sell_in) { -10 }
        Then { expect(item.quality).to eq initial_quality+2 }

        context "with max quality" do
          Given(:initial_quality) { 50 }
          Then { expect(item.quality).to eq initial_quality }
        end
      end
    end

    context "Sulfuras" do
      Given(:initial_quality) { 80 }
      Given(:name) { "Sulfuras, Hand of Ragnaros" }

      Invariant { expect(item.sell_in).to eq initial_sell_in }

      context "before sell date" do
        Then { expect(item.quality).to eq initial_quality }
      end

      context "on sell date" do
        Given(:initial_sell_in) { 0 }
        Then { expect(item.quality).to eq initial_quality }
      end

      context "after sell date" do
        Given(:initial_sell_in) { -10 }
        Then { expect(item.quality).to eq initial_quality }
      end
    end

    context "Backstage pass" do
      Given(:name) { "Backstage passes to a TAFKAL80ETC concert" }

      Invariant { expect(item.sell_in).to eq initial_sell_in-1 }

      context "long before sell date" do
        Given(:initial_sell_in) { 11 }
        Then { expect(item.quality).to eq initial_quality+1 }

        context "at max quality" do
          Given(:initial_quality) { 50 }
        end
      end

      context "medium close to sell date (upper bound)" do
        Given(:initial_sell_in) { 10 }
        Then { expect(item.quality).to eq initial_quality+2 }

        context "at max quality" do
          Given(:initial_quality) { 50 }
          Then { expect(item.quality).to eq initial_quality }
        end
      end

      context "medium close to sell date (lower bound)" do
        Given(:initial_sell_in) { 6 }
        Then { expect(item.quality).to eq initial_quality+2 }

        context "at max quality" do
          Given(:initial_quality) { 50 }
          Then { expect(item.quality).to eq initial_quality }
        end
      end

      context "very close to sell date (upper bound)" do
        Given(:initial_sell_in) { 5 }
        Then { expect(item.quality).to eq initial_quality+3 }

        context "at max quality" do
          Given(:initial_quality) { 50 }
          Then { expect(item.quality).to eq initial_quality }
        end
      end

      context "very close to sell date (lower bound)" do
        Given(:initial_sell_in) { 1 }
        Then { expect(item.quality).to eq initial_quality+3 }

        context "at max quality" do
          Given(:initial_quality) { 50 }
          Then { expect(item.quality).to eq initial_quality }
        end
      end

      context "on sell date" do
        Given(:initial_sell_in) { 0 }
        Then { expect(item.quality).to eq 0 }
      end

      context "after sell date" do
        Given(:initial_sell_in) { -10 }
        Then { expect(item.quality).to eq 0 }
      end
    end

    context "conjured item" do
      Given(:name) { "Conjured Mana Cake" }

      Invariant { expect(item.sell_in).to eq initial_sell_in-1 }

      context "before the sell date" do
        Given(:initial_sell_in) { 5 }
        Then { expect(item.quality).to eq initial_quality-2 }

        context "at zero quality" do
          Given(:initial_quality) { 0 }
          Then { expect(item.quality).to eq initial_quality }
        end
      end

      context "on sell date" do
        Given(:initial_sell_in) { 0 }
        Then { expect(item.quality).to eq initial_quality-4 }

        context "at zero quality" do
          Given(:initial_quality) { 0 }
          Then { expect(item.quality).to eq initial_quality }
        end
      end

      context "after sell date" do
        Given(:initial_sell_in) { -10 }
        Then { expect(item.quality).to eq initial_quality-4 }

        context "at zero quality" do
          Given(:initial_quality) { 0 }
          Then { expect(item.quality).to eq initial_quality }
        end
      end
    end
  end

  context "with several objects" do
    Given(:items) {
      [
        Item.new("NORMAL ITEM", 5, 10),
        Item.new("Aged Brie", 3, 10),
      ]
    }

    When { update_quality(items) }

    Then { expect(items[0].quality).to eq 9 }
    Then { expect(items[0].sell_in).to eq 4 }

    Then { expect(items[1].quality).to eq 11 }
    Then { expect(items[1].sell_in).to eq 2 }
  end
end
