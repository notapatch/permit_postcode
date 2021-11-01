require "rails_helper"

RSpec.describe Postcode, type: :model do
  describe "normalize" do
    it "has no effect on normalized postcode" do
      expect(Postcode.new("SW1A1AA").normalize).to eq "SW1A1AA"
    end

    it "normalizes a postcode with whitespace" do
      expect(Postcode.new("SW1A 1AA").normalize).to eq "SW1A1AA"
    end

    it "normalizes a postcode with lowercase letters" do
      expect(Postcode.new("sw1A 1aa").normalize).to eq "SW1A1AA"
    end
  end
end
