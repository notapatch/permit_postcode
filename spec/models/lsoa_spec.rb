require "rails_helper"

RSpec.describe Lsoa, type: :model do
  describe "#name_part" do
    it "returns the name part of the losa" do
      expect(Lsoa.new("Merton 006E").name_part).to eq "Merton"
    end

    it "returns the name part of a two word losa" do
      expect(Lsoa.new("Milton Keynes 014E").name_part).to eq "Milton Keynes"
    end
  end
end
